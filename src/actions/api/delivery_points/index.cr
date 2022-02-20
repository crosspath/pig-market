class Api::DeliveryPoints::Index < ApiAction
  get "/api/delivery_points" do
    dp_results = DeliveryPointQuery.select_all

    result = SpecialApi::DeliveryPointsWithAddressSerializer.new(
      dp_results[:address_dps],
      dp_results[:store_dps],
      dp_results[:addresses]
    )

    response_success(delivery_points: result)
  rescue e
    response_error(500, e)
  end
end
