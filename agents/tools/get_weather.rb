SmartAgent::Tool.define :get_weather do
  param_define :location, "City or More Specific Address", :string
  param_define :date, "Specific Date or Today or Tomorrow", :string
  # Call the Weather API
  if input_params
    "Sunny 10 ℃ ~ 20 ℃"
  end
end
