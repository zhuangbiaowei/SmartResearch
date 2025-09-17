SmartPrompt.define_worker :pre_search do
  use "deepseek"
  model "deepseek-reasoner"
  sys_msg "你是一个搜索专家，能够根据需要调用合适的搜索工具解决用户的问题。"
  prompt :pre_search, { text: params[:text] }
  response = send_msg
  response
end
