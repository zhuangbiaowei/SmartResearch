SmartAgent::Tool.define :smart_search do
  desc "能够调用其他搜索工具，完成复杂的深入搜索。在搜索完成后，还会将结果存入知识库"
  param_define :q, "搜索关键词", :string
  tool_proc do
    SmartResearch.logger.info "call_tool(:get_research_topics)"
    topics = call_tool(:get_research_topics)
    SmartResearch.logger.info "call_tool(:search)"
    result = call_tool(:search, { "query" => input_params["q"], "num" => 10 })
    SmartResearch.logger.info "call_tool(:get_topic)"
    suggestion_topic = call_worker(:get_topic, {
      topics: topics.to_s,
      search_result: result["content"][0]["text"],
    })
    if suggestion_topic.class == Hash
      s_topic = suggestion_topic.dig("choices", 0, "message", "content").strip
    else
      s_topic = suggestion_topic.to_s
    end
    SmartResearch.logger.info "call_tool(:create_research_topic)"
    topic_info = call_tool(:create_research_topic, { "name" => s_topic })
    search_result = JSON.parse(result.dig("content", 0, "text"))
    search_result.each do |sr|
      #puts "scrape url is: #{sr["link"]}"
      if SourceDocument.where(url: sr["link"]).empty?
        begin
          #SmartResearch.logger.info "call_tool(:scrape), url is #{sr["link"]}"
          SmartResearch.logger.info "fake call_tool(:scrape), url is #{sr["link"]}"
          # text = call_tool(:scrape, { "url" => sr["link"] })
          SmartResearch.logger.info "call_tool(:create_or_update_source_document_and_section)"
          call_tool(:create_or_update_source_document_and_section, {
            "topic" => JSON.parse(topic_info)["name"],
            "url" => sr["link"],
            "title" => sr["title"],
            "snippet" => sr["snippet"],
            "text" => "null", #text.dig("content", 0, "text"),
          })
        rescue => e
          SmartResearch.logger.info "文章抓取失败"
          SmartResearch.logger.info e.to_s
        end
      end
      #puts "save content done."
    end
    result
  end
end
