class SpecialApi::DeliveryPointsWithAddressSerializer < Lucky::Serializer
  def initialize(
    @address_dp : Array(UserAddressDeliveryPoint) | UserAddressDeliveryPointQuery,
    @store_dp : Array(UserStoreDeliveryPoint) | UserStoreDeliveryPointQuery
  ); end

  def render
    res = @address_dp.map do |u|
      Api::UserAddressDeliveryPointSerializer.new(u, u.address)
    end

    res = @store_dp.map do |u|
      Api::UserStoreDeliveryPointSerializer.new(u, u.store, u.store.try(&.address))
    end

    res
  end
end
