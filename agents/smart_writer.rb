def find_new_contents(query_processor, short_memory, query_text)
  results = query_processor.process_query(query_text, 3)
  contents = []
  results.each do |r|
    unless short_memory.find_mem(r[:url])
      short_memory.add_mem(r[:url], r[:content])
      contents << r[:content]
    end
  end
  return contents
end

def find_contents(query_processor, short_memory, query_text)
  results = query_processor.process_query(query_text, 5)
  contents = []
  results.each do |r|
    unless short_memory.find_mem(r[:url])
      short_memory.add_mem(r[:url], r[:content])
    end
    contents << short_memory.find_mem(r[:url])
  end
  return contents
end

def get_json(result)
  pattern = /```json\s*(.*?)\s*```/m
  match = result.match(pattern)
  json_str = match ? match[1].strip : "{}"
  if json_str == "{}"
    pattern = /\{(.*)\}/m
    match = result.match(pattern)
    json_str = match ? "{" + match[1].strip + "}" : "{}"
  end
  begin
    return JSON.parse(json_str)
  rescue JSON::ParserError
    return {}
  end
end

def generate_outline(query_text, query_processor, short_memory)
  # Check if outline.json exists and read it
  existing_outline = {}
  if File.exist?("reports/outline.json")
    begin
      existing_outline = JSON.parse(File.read("reports/outline.json"))
      show_log "发现已有提纲文件，将基于现有提纲进行修改"
    rescue JSON::ParserError
      show_log "现有提纲文件格式错误，将重新生成"
      existing_outline = {}
    end
  end

  contents = find_new_contents(query_processor, short_memory, query_text)
  show_log "找到#{contents.size}条记录"

  last_json = existing_outline
  while contents.size > 0
    # Include existing outline in the worker call for modification
    outline = call_worker(:preparation_outline, {
      query_text: query_text,
      contents: contents,
      existing_outline: last_json,
    }, with_tools: false, with_history: true)
    outline = outline.content
    outline_json = get_json(outline)

    if outline_json.empty?
      outline_json = last_json
    else
      last_json = outline_json
    end

    if outline_json["query"]
      contents = find_new_contents(query_processor, short_memory, outline_json["query"])
      show_log "又找到#{contents.size}条记录"
    else
      contents = []
    end
  end

  # Add original query to outline for reference
  outline_json["original_query"] = query_text

  # Save outline to reports/outline.json
  File.write("reports/outline.json", JSON.pretty_generate(outline_json))
  show_log "提纲已生成并保存到 reports/outline.json"
  return outline_json
end

def write_full_article(outline_json, query_processor, short_memory)
  # Use article info from outline if available, otherwise use defaults
  article_info = outline_json["article"] || {}
  file_name = "reports/" + article_info["file"] || "reports/report_#{Time.now.to_i}.md"
  article_title = article_info["title"]

  f = File.new(file_name, "w")
  f.puts("#{article_title}")

  outline_json["outline"].each do |id, chapter|
    contents = find_contents(query_processor, short_memory, article_title + "," + chapter["title"] + "," + chapter["summary"])
    show_log "针对章节：#{chapter["title"]}，又找到#{contents.size}条记录"

    chapter_text = call_worker(
      :chapter_writer,
      {
        outline: outline_json["outline"],
        contents: contents,
        title: chapter["title"],
        summary: chapter["summary"],
        length: chapter["length"],
        article_style: article_info["style"],
        article_audience: article_info["audience"],
      },
      with_tools: false,
      with_history: false,
    )
    f.puts "\n#{chapter["title"]}"
    f.puts chapter_text.content
    show_log "完成写作：#{chapter["title"]}"
  end
  f.close
  show_log "写作完成，内容存放在：#{file_name}"
  return file_name
end

def rewrite_chapter(chapter_id, new_instructions, query_text, query_processor, short_memory)
  # Load outline from file
  outline_json = JSON.parse(File.read("reports/outline.json")) if File.exist?("reports/outline.json")
  return show_log "请先生成提纲 (使用 outline 命令)" unless outline_json

  chapter = outline_json["outline"][chapter_id.to_s]
  return show_log "未找到章节 #{chapter_id}" unless chapter

  show_log "正在重写章节: #{chapter["title"]}"

  # Find content for this specific chapter
  contents = find_contents(query_processor, short_memory, query_text + "," + chapter["title"] + "," + chapter["summary"] + "," + new_instructions)

  # Rewrite the chapter with new instructions
  article_info = outline_json["article"] || {}
  rewritten_chapter = call_worker(
    :chapter_writer,
    {
      outline: outline_json["outline"],
      contents: contents,
      title: chapter["title"],
      summary: chapter["summary"],
      length: chapter["length"],
      instructions: new_instructions,
      article_style: article_info["style"],
      article_audience: article_info["audience"],
    },
    with_tools: true,  # Enable tools for modify_file
    with_history: false,
  )

  show_log "章节重写完成: #{chapter["title"]}"

  # Try to find the report file to update
  article_info = outline_json["article"] || {}
  file_name = "reports/" + (article_info["file"] || "report_#{Time.now.to_i}.md")

  if File.exist?(file_name)
    # Read current content to find the chapter
    current_content = File.read(file_name)
    lines = current_content.lines

    # Find the chapter section
    chapter_header = "#{chapter["title"]}"
    chapter_start = lines.index { |line| line.strip == chapter_header }

    if chapter_start
      # Find the end of this chapter (next header or end of file)
      chapter_end = lines[chapter_start + 1..-1].index { |line| line.start_with?("##") }
      chapter_end = chapter_end ? chapter_start + 1 + chapter_end : lines.length

      # Create diff to replace the chapter content
      diff_content = ""
      # Keep the header line
      diff_content += " #{lines[chapter_start]}"
      # Remove old content
      (chapter_start + 1...chapter_end).each do |i|
        diff_content += "-#{lines[i]}"
      end
      # Add new content
      rewritten_chapter.content.lines.each do |line|
        diff_content += "+#{line}"
      end

      # Use modify_file tool to update the file
      modify_result = call_tool(:modify_file, {
        filename: file_name,
        diff_txt: diff_content,
      })

      show_log "文件已更新: #{modify_result}"
    else
      show_log "警告: 在文件中未找到章节 '#{chapter["title"]}'，重写内容将仅显示而不保存"
    end
  else
    show_log "警告: 报告文件 #{file_name} 不存在，重写内容将仅显示而不保存"
  end

  return rewritten_chapter.content
end

SmartAgent.define :smart_writer do
  query_processor = QueryProcessor.new(SmartAgent.prompt_engine)
  short_memory = ShortMemory.new
  input = params[:text]

  if input.downcase == "h" || input.downcase == "help"
    show_log "帮助信息："
    show_log "h/help                  显示帮助"
    show_log "outline [主题]          生成文章提纲并保存到 outline.json"
    show_log "outline [讨论]          根据讨论，修改提纲文件 outline.json 的内容"
    show_log "outline                 列出当前提纲"
    show_log "del                     删除原本存在的 outline.json 文件"
    show_log "write_all / wa          根据 outline.json 生成完整文章"
    show_log "rewrite [章节ID] [指令]  重写指定章节"
    show_log "  示例: rewrite 1. 请用更专业的语言重写这个章节"
  elsif input.downcase.start_with?("outline ")
    query_text = input[7..-1].strip
    generate_outline(query_text, query_processor, short_memory)
  elsif input.downcase == "outline"
    if File.exist?("reports/outline.json")
      outline_json = JSON.parse(File.read("reports/outline.json"))
      show_log JSON.pretty_generate(outline_json)
    else
      show_log "outline.json文件不存在"
    end
  elsif input.downcase.start_with?("del")
    if File.exist?("reports/outline.json")
      File.delete("reports/outline.json")
      show_log "outline.json文件已经删除"
    end
  elsif input.downcase.start_with?("write_all") || input.downcase == "wa"
    if File.exist?("reports/outline.json")
      outline_json = JSON.parse(File.read("reports/outline.json"))
      write_full_article(outline_json, query_processor, short_memory)
    else
      show_log "请先生成提纲 (使用 outline 命令)"
    end
  elsif input.downcase.start_with?("rewrite ")
    parts = input[8..-1].strip.split(" ", 2)
    if parts.size >= 2
      chapter_id = parts[0]
      instructions = parts[1]
      # Use the original query text from the outline if available
      outline_json = JSON.parse(File.read("reports/outline.json")) if File.exist?("reports/outline.json")
      query_text = outline_json["original_query"] if outline_json && outline_json["original_query"]
      query_text ||= ""

      rewritten_content = rewrite_chapter(chapter_id, instructions, query_text, query_processor, short_memory)
      show_log "重写后的内容："
      show_log rewritten_content
    else
      show_log "用法: rewrite [章节ID] [指令]"
    end
  else
    show_log "请输入正确的命令，使用 'h' 查看帮助"
  end
end

SmartAgent.build_agent(
  :smart_writer,
  tools: [:modify_file],
)
