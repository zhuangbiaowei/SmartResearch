SmartAgent.define :smart_bot do
  result = call_worker(:smart_bot, params, with_tools: true)
  if result.call_tools
    tool_result = call_tools(result)
    result = call_worker(:summary, params, result: tool_result.to_s, with_tools: false)
  end
  if result != true
    result.response
  else
    result
  end
end

SmartAgent.build_agent(:smart_bot, tools: [:get_weather, :get_sum, :search], mcp_servers: [:opendigger])
