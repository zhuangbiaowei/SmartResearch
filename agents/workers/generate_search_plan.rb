SmartPrompt.define_worker :generate_search_plan do
  use "deepseek"
  model "deepseek-reasoner"
  sys_msg "你是一个搜索规划专家，能够基于初步搜索结果生成详细的搜索执行计划，包括搜索方向、关键词优化和搜索策略。"
  prompt :generate_search_plan, { text: params[:text] }
  response = send_msg
  response
end