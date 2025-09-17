SmartPrompt.define_worker :get_conversation_name do
  use "SiliconFlow"
  model "deepseek-ai/DeepSeek-V3"
  prompt :get_conversation_name, {content: params[:content]}
  send_msg
end