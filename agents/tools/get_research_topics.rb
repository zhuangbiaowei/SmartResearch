SmartAgent::Tool.define :get_research_topics do
  desc "获取所有研究主题"
  tool_proc do
    topics = ResearchTopic.all_topics
    topics.map { |topic| { id: topic.id, name: topic.name, description: topic.description } }.to_json
  end
end
