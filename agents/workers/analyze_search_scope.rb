SmartPrompt.define_worker :analyze_search_scope do
  use "deepseek"
  model "deepseek-reasoner"
  sys_msg "你是一个搜索策略专家，能够分析用户问题的类型并确定最佳的初始搜索范围。根据问题内容判断搜索方向、范围和关键词策略。"
  prompt :analyze_search_scope, { text: params[:text] }
  response = send_msg
  response
end