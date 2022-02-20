class Api::Goods::Index < ApiAction
  get "/api/goods" do
    goods = GoodQuery.new.name.asc_order

    result = Api::GoodSerializer.for_collection(goods)

    response_success(goods: result)
  rescue e
    response_error(500, e)
  end
end
