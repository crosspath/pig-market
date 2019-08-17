class SpecialApi::DeliveryPointsWithAddressSerializer < Lucky::Serializer
  def initialize(
    @address_dp : Array(UserAddressDeliveryPoint) | UserAddressDeliveryPointQuery,
    @store_dp : Array(UserStoreDeliveryPoint) | UserStoreDeliveryPointQuery,
    @addresses : Hash(Int32, Array(Address))
  ); end

  def render
    {
      to_user_address: @address_dp.map do |u|
        Api::UserAddressDeliveryPointSerializer.new(u, u.address)
      end,

      to_store: @store_dp.map do |u|
        address = @addresses[u.store.try(&.address_id)]?.try(&.first)
        Api::UserStoreDeliveryPointSerializer.new(u, u.store, address)
      end
    }
  end
end
