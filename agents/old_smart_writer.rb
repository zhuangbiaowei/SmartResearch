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

SmartAgent.define :smart_writer do
  query_processor = QueryProcessor.new(SmartAgent.prompt_engine)
  short_memory = ShortMemory.new
  query_text = params[:text]
  contents = find_new_contents(query_processor, short_memory, query_text)

  show_log "找到#{contents.size}条记录"
  last_json = {}
  while (contents.size > 0)
    outline = call_worker(:preparation_outline, { query_text: query_text, contents: contents }, with_tools: false, with_history: true)
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
  file_name = "reports/report_#{Time.now.to_i}.md"
  f = File.new(file_name, "w")
  f.puts("# #{query_text}")
  outline_json["outline"].each do |id, chapter|
    contents = find_contents(query_processor, short_memory, query_text + "," + chapter["title"] + "," + chapter["summary"])

    show_log "针对章节：#{chapter["title"]}，又找到#{contents.size}条记录"

    chapter_text = call_worker(
      :chapter_writer,
      {
        outline: outline_json["outline"],
        contents: contents,
        title: chapter["title"],
        summary: chapter["summary"],
      },
      with_tools: false,
      with_history: false,
    )
    f.puts chapter["title"]
    f.puts chapter_text.content
    show_log "完成写作：#{chapter["title"]}"
  end
  f.close

  show_log "写作完成，内容存放在：#{file_name}"
end

SmartAgent.build_agent(
  :smart_writer
)
