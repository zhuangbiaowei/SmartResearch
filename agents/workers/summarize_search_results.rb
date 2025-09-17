SmartPrompt.define_worker :summarize_search_results do
  #use "SiliconFlow"
  #model "moonshotai/Kimi-K2-Instruct"
  use "shengsuanyun"
  model "moonshot/kimi-k2"
  prompt :summarize_results, { ask: params[:ask], text: params[:text] }
  send_msg
end
