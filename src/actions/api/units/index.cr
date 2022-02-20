class Api::Units::Index < ApiAction
  get "/api/units" do
    units = UnitQuery.new.name.asc_order

    result = Api::UnitSerializer.for_collection(units)

    response_success(units: result)
  rescue e
    response_error(500, e)
  end
end
