abstract class ApiAction < Lucky::Action
  # Include modules and add methods that are for all API requests

  before check_api_key
  before set_cors_headers

  protected def check_api_key
    if params.get?(:api_key) == ENV["API_KEY"]?
      continue
    else
      response_error(100)
    end
  end

  protected def set_cors_headers
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] =
        "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range"
    continue
  end

  protected def response_success(**options)
    result = {status: 200}
    json result.merge(options)
  end

  protected def response_error(code, exception : Exception? = nil, **options)
    result = {status: code}.merge(options)

    if exception
      result = result.merge(
        message: exception.as(Exception).message,
        trace:   exception.backtrace
      )
    end

    json result, Status::UnprocessableEntity
  end
end
