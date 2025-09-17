SmartPrompt::Worker.define :get_topic do
  #use "SiliconFlow"
  use "Aliyun"
  model "Moonshot-Kimi-K2-Instruct"
  sys_msg "你能帮我处理各种文本内容，并给我简洁但是有效的结果。"
  prompt :get_topic, {
    topics: params[:topics],
    search_result: params[:search_result],
  }
  send_msg
end
