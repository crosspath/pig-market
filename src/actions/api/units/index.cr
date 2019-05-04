class Api::Units::Index < ApiAction
  route do
    units = UnitQuery.new.name.asc_order

    result = Api::UnitsSerializer.new(units)

    response_success(units: result)
  rescue e
    response_error(500, e)
  end
end
