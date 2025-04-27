SmartPrompt.define_worker :summary do
  #use "SiliconFlow"
  #model "deepseek-ai/DeepSeek-V3"
  use "deepseek"
  model "deepseek-chat"
  #sys_msg "你是一个强大的整理信息的助手，你主要用中文回答问题。"
  prompt :summarize, { text: params[:text], tool_result: params[:result] }
  send_msg
end
