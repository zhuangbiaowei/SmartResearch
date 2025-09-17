require "net/http"
require "uri"
require "json"

SmartAgent::Tool.define :meta_scrape do
  desc "根据输入的URL，抓取网页，返回Markdown格式"
  param_define :url, "网址", :string
  tool_proc do
    uri = URI("https://metaso.cn/api/v1/reader")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer mk-7398331BB5BBB5EB5B8070ED670605D8"
    request["Accept"] = "text/plain"
    request["Content-Type"] = "application/json"
    request.body = { url: input_params["url"] }.to_json
    response = http.request(request)
    response.body
  end
end
