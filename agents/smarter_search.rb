SmartAgent.define :smarter_search do
  question = params[:text]

  # 第一步：分析问题类型并确定初始搜索范围
  result = call_worker(:analyze_search_scope, params, with_tools: false, with_history: true)
  show_log("问题分析完成")

  # 第二步：基于分析结果进行初步搜索
  params[:text] = "根据以下分析进行初步搜索：#{result.content}"
  result = call_worker(:pre_search, params, with_tools: true, with_history: true)
  show_log("初步搜索完成")

  if result.call_tools
    call_tools(result)

    # 第三步：生成详细的搜索规划
    params[:text] = "基于初步搜索结果，请输出一份详细的搜索规划"
    result = call_worker(:generate_search_plan, params, with_tools: false, with_history: true)
    show_log("搜索规划生成完成")
  end

  # 第四步：执行详细搜索
  params[:text] = result.content
  result = call_worker(:smart_search, params, with_tools: true, with_history: true)
  show_log("详细搜索完成")

  if result.call_tools
    call_tools(result)
  end

  # 第五步：总结搜索结果
  params[:text] = question
  result = call_worker(:summary, params, with_tools: false, with_history: true)
  show_log("搜索结果总结完成")

  if result.call_tools
    call_tools(result)
    result = call_worker(:summary, params, with_tools: false, with_history: true)
    show_log("")
  end

  result.content
end

SmartAgent.build_agent(
  :smarter_search,
  tools: [:smart_search],
  mcp_servers: [:opendigger],
)
