SmartAgent.define :smart_search do
  question = params[:text]
  result = call_worker(:pre_search, params, with_tools: true, with_history: true)
  show_log("")
  if result.call_tools
    call_tools(result)
    params[:text] = "请输出一份搜索规划"
    result = call_worker(:pre_search, params, with_tools: true, with_history: true)
    show_log("")
  end
  params[:text] = result.content
  result = call_worker(:smart_search, params, with_tools: true, with_history: true)
  show_log("")
  if result.call_tools
    call_tools(result)
  end
  params[:text] = question
  result = call_worker(:summary, params, with_tools: false, with_history: true)
  show_log("")
  if result.call_tools
    call_tools(result)
    result = call_worker(:summary, params, with_tools: false, with_history: true)
    show_log("")
  end
  result.content
end

SmartAgent.build_agent(
  :smart_search,
  tools: [:smart_search],
  mcp_servers: [:opendigger],
)
