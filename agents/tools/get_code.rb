SmartAgent::Tool.define :get_code do
  param_define :name, "ruby function name", :string
  param_define :description, "ruby function description", :string
  param_define :input_params_type, "define of input parameters: (name:type, name:type ... )", :string
  param_define :output_value_type, "type of return value.", :string
  param_define :input_params, "input parameters: (value, value ...)", :string
  if input_params
    code = call_worker(:get_code, input_params)
    if input_params["input_params"][0] == "(" && input_params["input_params"][-1] == ")"
      code += "\n" + input_params["name"] + input_params["input_params"]
    else
      code += "\n" + input_params["name"] + "(" + input_params["input_params"] + ")"
    end
    "通过生成的代码:\n #{code} \n得到了结果: #{eval(code)}"
  end
end
