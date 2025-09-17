SmartPrompt.define_worker :chapter_writer do
  use "SiliconFlow"
  model "moonshotai/Kimi-K2-Instruct"
  #use "shengsuanyun"
  #model "moonshot/kimi-k2"
  #use "Aliyun"
  #model "qwen-plus"
  prompt :chapter_writer, params
  send_msg
end
