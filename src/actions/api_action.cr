abstract class ApiAction < Lucky::Action
  # Include modules and add methods that are for all API requests

  before check_api_key

  protected def check_api_key
    if params.get?(:api_key) == ENV["API_KEY"]?
      continue
    else
      response_error(100)
    end
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
