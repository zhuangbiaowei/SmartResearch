SmartPrompt.define_worker :get_tags do
  #use "SiliconFlow"
  #model "deepseek-ai/DeepSeek-R1-0528-Qwen3-8B"
  #use "deepseek"
  #model "deepseek-chat"
  #use "shengsuanyun"
  #model "deepseek/deepseek-v3"
  use "Aliyun"
  model "qwen-flash"
  #use "ollama"
  #model "qwen3"
  params[:lang] = "简体中文" unless params[:lang]
  prompt :get_tags, params
  send_msg
end
