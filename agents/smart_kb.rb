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

def chunk_content(content, max_chars = 4000)
  return [content] if content.length <= max_chars

  chunks = []
  current_chunk = ""

  # Split by paragraphs first
  paragraphs = content.split(/\n\n+/)

  paragraphs.each do |paragraph|
    if current_chunk.length + paragraph.length + 2 <= max_chars
      current_chunk += paragraph + "\n\n"
    else
      if current_chunk.length > 0
        chunks << current_chunk.strip
        current_chunk = ""
      end

      # If a single paragraph is too long, split by sentences
      if paragraph.length > max_chars
        sentences = paragraph.split(/(?<=[.!?])\s+/)
        sentences.each do |sentence|
          if current_chunk.length + sentence.length + 1 <= max_chars
            current_chunk += sentence + " "
          else
            chunks << current_chunk.strip if current_chunk.length > 0
            current_chunk = sentence + " "
          end
        end
      else
        current_chunk = paragraph + "\n\n"
      end
    end
  end

  chunks << current_chunk.strip if current_chunk.length > 0
  chunks
end

def process_content_chunks(doc_id, title, content, topic_ids)
  topic_ids = ResearchTopic.select_map(:id) if topic_ids.empty?
  chunks = chunk_content(content)
  section_ids = []

  chunks.each_with_index do |chunk, index|
    section_title = chunks.size > 1 ? "#{title} (Part #{index + 1}/#{chunks.size})" : title

    # Create or update SourceSection record
    section = SourceSection.create_section(doc_id, "null", section_title)
    section.content = chunk
    section.section_number = index + 1
    section.save

    section_ids << section.id

    # Generate embedding for the chunk
    text = "#{section_title}\n#{chunk}"
    begin
      unless text.empty?
        result = call_worker(:get_embedding, { text: text, length: 1024 })
        Embedding.create_embedding(section.id, "[#{result.response.join(",")}]")
      end
      show_log "嵌入数据保存成功 (Part #{index + 1})"
    rescue => e
      show_log "嵌入数据保存失败 (Part #{index + 1}): #{e.message}"
    end

    # Process tags for each topic
    topic_ids.each do |topic_id|
      topic = ResearchTopic[topic_id]
      tags = call_worker(:get_tags, { topic: topic.name, text: text })
      begin
        json_obj = get_json(tags.content)
        unless json_obj.empty?
          type_tag = Tag.find_or_create_by_name(json_obj["Type"])
          section[:tag_id] = type_tag[:id]
          section.save
          ResearchTopicSection.create_link(topic_id, section.id)
          ResearchTopicTag.create_link(topic.id, type_tag[:id])
          json_obj["Tags"].each do |tag|
            new_tag = Tag.find_or_create_by_name(tag)
            SectionTag.create_link(section[:id], new_tag[:id])
          end
          show_log "标签保存成功 (Part #{index + 1})"
        end
      rescue => e
        show_log "标签处理失败 (Part #{index + 1}): #{e.message}"
      end
    end
  end
  section_ids
end

SmartAgent::Agent.define :smart_kb do
  query_processor = QueryProcessor.new(SmartAgent.prompt_engine)
  short_memory = ShortMemory.new
  input = params[:text]
  if input.downcase == "h" || input.downcase == "help"
    show_log "帮助信息："
    show_log "h/help             显示帮助"
    show_log "l/list             列出研究主题"
    show_log "l [num]/list [num] 列出特定主题下的文档标题"
    show_log "ll [num]           列出特定文档的内容"
    show_log "d [num]            下载指定正文内容"
    show_log "d [url]            下载指定URL的内容并保存"
    show_log "dd [num]           下载特定主题下的所有正文内容"
    show_log "ask [question]     向知识库提问"
    show_log "del [num]          删除指定的章节"
    show_log "dall               下载所有未能完成下载的内容"
  elsif input.downcase == "l" || input.downcase == "list"
    ResearchTopic.order_by(:id).each do |topic|
      show_log "#{topic[:id]}" + " " * (4 - "#{topic[:id]}".size) + topic[:name]
    end
  elsif input.downcase[0..1] == "l " && input[2..-1].to_i > 0
    topic_id = input[2..-1].to_i
    doc_list = []
    ResearchTopicSection.order_by(:section_id).where_all(research_topic_id: topic_id).each do |rts|
      section = SourceSection[rts[:section_id]]
      doc = SourceDocument[section[:document_id]]
      unless doc_list.include?(doc.id)
        doc_list << doc.id
        show_log "#{doc[:id]}" + " " * (4 - "#{doc[:id]}".size) + doc[:title]
        if section.content == "null"
          show_log "     null"
        end
      end
    end
  elsif input.downcase[0..2] == "ll " && input[3..-1].to_i > 0
    doc_id = input[3..-1].to_i
    doc = SourceDocument[doc_id]
    show_log doc[:title]
    section_ids = []
    SourceSection.order_by(:id).where_all(document_id: doc_id).each do |section|
      section_ids << section.id
      show_log section[:content]
      tag_ids = SectionTag.order_by(:tag_id).where(section_id: section.id).select_map(:tag_id)
      show_log "Tags: " + Tag.where(id: tag_ids).select_map(:name).to_s
    end
  elsif input.downcase[0..1] == "d " && input[2..-1].to_i > 0
    doc_id = input[2..-1].to_i
    doc = SourceDocument[doc_id]
    show_log doc[:url]
    content = call_worker(:download_page, { url: doc[:url] })

    # Extract title from content
    pattern = /\[title\]\s*(.*?)\s*\[\/title\]/m
    match = content.content.match(pattern)
    title = match ? match[1] : doc[:title] || "Untitled"
    md_content = content.content.gsub(/\[title\].*?\[\/title\]/m, "").strip
    section_ids = SourceSection.where(document_id: doc[:id]).select_map(:id)
    topic_ids = ResearchTopicSection.where(section_id: section_ids).select_map(:research_topic_id).uniq
    # 删除与该文档相关的所有SectionTag记录
    SourceSection.where(document_id: doc_id).each do |section|
      SectionTag.where(section_id: section.id).delete
    end

    # 删除与该文档相关的所有Embedding记录
    SourceSection.where(document_id: doc_id).each do |section|
      Embedding.where(source_id: section.id).delete
    end

    # 删除所有topic与section之间的关联
    ResearchTopicSection.where(section_id: section_ids).delete

    # 删除与该文档相关的所有SourceSection记录
    SourceSection.where(document_id: doc_id).delete

    # Process content with chunking
    process_content_chunks(doc_id, title, md_content, topic_ids)
    show_log "下载并分片保存完成"
  elsif input.downcase[0..1] == "d " && (input[2..-1].include?("https://") || input[2..-1].include?("http://"))
    url = input[2..-1]
    content = call_worker(:download_page, { url: url })

    # Extract title from content
    md_content = content.content
    pattern = /\[title\]\s*(.*?)\s*\[\/title\]/m
    match = md_content.match(pattern)
    title = match ? match[1] : ""
    md_content = md_content.gsub(/\[title\].*?\[\/title\]/m, "").strip

    # 创建或更新SourceDocument记录
    doc = SourceDocument.find_or_create_by_url(url)
    doc.title = title
    doc.save

    # Process content with chunking
    process_content_chunks(doc[:id], title, md_content)
    show_log "下载并分片保存完成"
  elsif input.downcase[0..3] == "del " && input[4..-1].to_i > 0
    doc_id = input[4..-1].to_i
    doc = SourceDocument[doc_id]
    if doc
      # 删除与该文档相关的所有SectionTag记录
      SourceSection.where(document_id: doc_id).each do |section|
        SectionTag.where(section_id: section.id).delete
      end

      # 删除与该文档相关的所有Embedding记录
      SourceSection.where(document_id: doc_id).each do |section|
        Embedding.where(source_id: section.id).delete
      end

      # 删除与该文档相关的所有SourceSection记录
      SourceSection.where(document_id: doc_id).delete

      # 删除SourceDocument记录
      doc.delete

      show_log "文档及其相关记录已删除"
    else
      show_log "未找到指定的文档"
    end
  elsif input.downcase[0..3] == "ask "
    question = input[4..-1]
    contents = find_new_contents(query_processor, short_memory, question)
    show_log "找到#{contents.size}条记录"
    call_worker(:summary, { text: "问题：" + question + "\n回答：" + contents.to_s })
  elsif input.downcase[0..2] == "dd " && input[3..-1].to_i > 0
    topic_id = input[2..-1].to_i
    doc_list = []
    ResearchTopicSection.order_by(:section_id).where_all(research_topic_id: topic_id).each do |rts|
      section = SourceSection[rts[:section_id]]
      doc = SourceDocument[section[:document_id]]
      unless doc_list.include?(doc.id)
        doc_list << doc.id
        if section.content == "null"
          begin
            show_log "下载： #{doc[:url]}"
            content = call_worker(:download_page, { url: doc[:url] })
            unless content.content.empty?
              pattern = /\[title\]\s*(.*?)\s*\[\/title\]/m
              match = content.content.match(pattern)
              title = match ? match[1] : doc[:title] || "Untitled"
              md_content = content.content.gsub(/\[title\].*?\[\/title\]/m, "").strip
              if md_content.include?("读取PDF时出错")
                show_log "PDF解析失败"
                next
              end
              section_ids = SourceSection.where(document_id: doc.id).select_map(:id)
              topic_ids = ResearchTopicSection.where(section_id: section_ids).select_map(:research_topic_id).uniq
              # 删除与该文档相关的所有SectionTag记录
              SourceSection.where(document_id: doc.id).each do |section|
                SectionTag.where(section_id: section.id).delete
              end

              # 删除与该文档相关的所有Embedding记录
              SourceSection.where(document_id: doc.id).each do |section|
                Embedding.where(source_id: section.id).delete
              end

              # 删除所有topic与section之间的关联
              ResearchTopicSection.where(section_id: section_ids).delete

              # 删除与该文档相关的所有SourceSection记录
              SourceSection.where(document_id: doc.id).delete

              # Process content with chunking
              process_content_chunks(doc.id, title, md_content, topic_ids)
              show_log "下载并分片保存完成"
            end
          rescue => e
            show_log "下载失败: #{e.message}"
          end
        end
      end
    end
  elsif input.downcase == "dall"
    SourceSection.order_by(:id).where(content: "null").select_map(:id).each do |section_id|
      section = SourceSection[section_id]
      doc = SourceDocument[section.document_id]
      show_log "下载： #{doc[:url]}"
      begin
        content = call_worker(:download_page, { url: doc[:url] })
        unless content.content.empty?
          pattern = /\[title\]\s*(.*?)\s*\[\/title\]/m
          match = content.content.match(pattern)
          title = match ? match[1] : doc[:title] || "Untitled"
          md_content = content.content.gsub(/\[title\].*?\[\/title\]/m, "").strip
          if md_content.include?("读取PDF时出错")
            show_log "PDF解析失败"
            next
          end
          section_ids = SourceSection.where(document_id: doc.id).select_map(:id)
          topic_ids = ResearchTopicSection.where(section_id: section_ids).select_map(:research_topic_id).uniq
          # 删除与该文档相关的所有SectionTag记录
          SourceSection.where(document_id: doc.id).each do |section|
            SectionTag.where(section_id: section.id).delete
          end

          # 删除与该文档相关的所有Embedding记录
          SourceSection.where(document_id: doc.id).each do |section|
            Embedding.where(source_id: section.id).delete
          end

          # 删除所有topic与section之间的关联
          ResearchTopicSection.where(section_id: section_ids).delete

          # 删除与该文档相关的所有SourceSection记录
          SourceSection.where(document_id: doc.id).delete

          # Process content with chunking
          process_content_chunks(doc.id, title, md_content, topic_ids)
          show_log "下载并分片保存完成"
        end
      rescue => e
        show_log "下载失败: #{e.message}"
      end
    end
  else
    show_log "请输入正确的命令"
  end
end

SmartAgent.build_agent(
  :smart_kb
)
