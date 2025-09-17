SmartPrompt.define_worker :smart_search do
  use "deepseek"
  model "deepseek-chat"
  sys_msg "你是一个搜索专家，请根据用户的明确搜索要求，调用对应的搜索工具，不要使用`company-search`！不要使用`scrape`！不要使用`sequentialthinking`！在调用工具时，请输出完全正确的JSON格式！每次对话都可以调用多个工具。"
  prompt :smart_search, { text: params[:text] }
  send_msg
end
