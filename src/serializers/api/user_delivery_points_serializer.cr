class Api::UserDeliveryPointsSerializer < Lucky::Serializer
  def initialize(
    @address_dp : UserAddressDeliveryPointQuery | Array(UserAddressDeliveryPoint),
    @store_dp : UserStoreDeliveryPointQuery | Array(UserStoreDeliveryPoint)
  ); end

  def render
    {
      user_address_delivery_points: @address_dp.map do |u|
        Api::UserAddressDeliveryPointSerializer.new(u, with_order: false, with_address: true)
      end,
      user_store_delivery_points: @store_dp.map do |u|
        Api::UserStoreDeliveryPointSerializer.new(u, with_order: false, with_store: true)
      end
    }
  end
end
