SmartPrompt.define_worker :smart_bot do
  #use "deepseek"
  #model "deepseek-chat"
  use "SiliconFlow"
  model "deepseek-ai/DeepSeek-V3"
  sys_msg "你是一个聪明的智能助手，能够根据需要调用合适的工具解决用户的问题，如果是关于开源的问题，则调用opendigger，如果是较为复杂需要多步骤处理的问题，则调用sequentialthinking_tools。"
  prompt :summarize, { text: params[:text] }
  send_msg
end
