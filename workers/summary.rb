SmartPrompt.define_worker :summary do
  use "SiliconFlow"
  model "Pro/deepseek-ai/DeepSeek-V3"
  sys_msg "You are a helpful assistant."
  prompt :summarize, { text: params[:text], tool_result: params[:result] }
  send_msg
end
