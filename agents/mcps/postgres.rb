SmartAgent::MCPClient.define :postgres do
  type :stdio
  command "node /root/servers/src/postgres/dist/index.js postgres://docs:ment@localhost/docs"
end
