SmartAgent::Tool.define :create_research_topic do
  desc "创建新的研究主题"
  param_define :name, "研究主题名称", :string
  param_define :description, "研究主题描述", :string
  tool_proc do
    begin
      topic = ResearchTopic.create_or_find_topic(input_params["name"], input_params["description"] || nil)
      { id: topic.id, name: topic.name, description: topic.description }.to_json
    rescue Sequel::ValidationFailed => e
      { error: e.message }.to_json
    end
  end
end
