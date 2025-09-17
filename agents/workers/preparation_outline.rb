SmartPrompt::Worker.define :preparation_outline do
  use "Aliyun"
  model "qwen-plus"
  #use "SiliconFlow"
  #model "deepseek-ai/DeepSeek-V3.1"
  sys_msg "你是一个专业写作者，正在帮我准备一个提纲，请参考输入内容与讨论的历史，给出一个尽可能完善的成果。"
  prompt :preparation_outline, params
  send_msg
end
