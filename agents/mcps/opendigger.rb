SmartAgent::MCPClient.define :opendigger do
  type :stdio
  command "node /root/open-digger-mcp-server/dist/index.js"
end
