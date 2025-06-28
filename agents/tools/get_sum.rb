SmartAgent::Tool.define :get_sum do
  param_define :a, "number", :integer
  param_define :b, "number", :integer
  tool_proc do
    input_params["a"] + input_params["b"]
  end
end
