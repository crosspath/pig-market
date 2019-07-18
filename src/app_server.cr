class AppServer < Lucky::BaseAppServer
  def middleware
    [
      Lucky::HttpMethodOverrideHandler.new,
      Lucky::LogHandler.new,
      Lucky::SessionHandler.new,
      Lucky::FlashHandler.new,
      Lucky::ErrorHandler.new(action: Errors::Show),
      Lucky::RouteHandler.new,
      Lucky::StaticFileHandler.new("./public", false),
      Lucky::RouteNotFoundHandler.new,
    ]
  end
  
  def protocol
    "http"
  end
  
  def listen
    server.bind_tcp(host, port, reuse_port: false)
    server.listen
  end
end