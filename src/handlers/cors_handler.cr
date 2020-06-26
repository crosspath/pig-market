class CORSHandler
  include HTTP::Handler

  HEADERS = "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range"

  def call(context : HTTP::Server::Context)
    context.response.headers["Access-Control-Allow-Origin"] = "*"
    context.response.headers["Access-Control-Allow-Headers"] = HEADERS
    context.response.headers["Access-Control-Allow-Methods"] = "*"

    # If this is an OPTIONS call, respond with just the needed headers.
    if context.request.method == "OPTIONS"
      context.response.status = HTTP::Status::NO_CONTENT
      context.response.headers["Access-Control-Max-Age"] = "#{20.days.total_seconds.to_i}"
      context.response.headers["Content-Type"] = "text/plain"
      context.response.headers["Content-Length"] = "0"
      context
    else
      call_next(context)
    end
  end
end
