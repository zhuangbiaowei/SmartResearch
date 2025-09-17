SmartAgent::Tool.define :create_or_update_source_document_and_section do
  desc "创建源文档和章节"
  param_define :topic, "研究主题", :string
  param_define :url, "文档来源", :string
  param_define :title, "文档标题", :string
  param_define :snippet, "文档摘要", :string
  param_define :text, "文档内容", :string
  tool_proc do
    begin
      # 根据 URL 查找源文档，找不到就新建，找到就更新
      document = SourceDocument.where(url: input_params["url"]).first
      if document
        # 更新现有文档
        document.update(
          title: input_params["title"],
          description: input_params["snippet"],
        )
      else
        # 创建新文档
        document = SourceDocument.create(
          title: input_params["title"],
          url: input_params["url"],
          description: input_params["snippet"],
        )
      end

      # 创建或更新源章节
      # 先尝试查找是否已存在相同 document_id 和内容的章节
      section = SourceSection.where(document_id: document.id, content: input_params["text"]).first
      unless section
        section = SourceSection.create(
          document_id: document.id,
          content: input_params["text"],
        )
      end

      # 根据传入的 topic 内容，添加记录到 research_topic_sections 表
      unless input_params["topic"].nil? || input_params["topic"].empty?
        # 查找或创建研究主题
        topic = ResearchTopic.create_or_find_topic(input_params["topic"])

        # 创建研究主题与章节的关联（避免重复）
        unless ResearchTopicSection.find_by_topic_and_section(topic.id, section.id)
          ResearchTopicSection.create_link(topic.id, section.id)
        end
      end

      {
        document: { id: document.id, title: document.title, url: document.url, description: document.description },
        section: { id: section.id, content: section.content },
      }.to_json
    rescue Sequel::ValidationFailed => e
      { error: e.message }.to_json
    rescue Sequel::MassAssignmentRestriction => e
      { error: "权限错误: #{e.message}" }.to_json
    end
  end
end
