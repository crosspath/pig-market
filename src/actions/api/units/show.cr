class Api::Units::Show < ApiAction
  get "/api/units/:unit_id" do
    unit = UnitQuery.new.preload_goods.find(unit_id)

    result = Api::UnitSerializer.new(unit, unit.goods)

    response_success(unit: result)
  rescue e
    response_error(500, e)
  end
end
