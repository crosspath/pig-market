class Api::UserDeliveryPointsSerializer < Lucky::Serializer
  def initialize(
    @address_dp : UserAddressDeliveryPointQuery | Array(UserAddressDeliveryPoint),
    @store_dp : UserStoreDeliveryPointQuery | Array(UserStoreDeliveryPoint)
  ); end

  def render
    {
      user_address_delivery_points: @address_dp.map do |u|
        address = u.address
        {
          id: u.id,
          hidden: u.hidden,
          address_notes: u.address_notes,
          address: address ? {
            id: address.id,
            city: address.city,
            street: address.street,
            building: address.building
          } : nil
        }
      end,
      user_store_delivery_points: @store_dp.map do |u|
        store = u.store
        address = store ? store.address : nil
        {
          id: u.id,
          hidden: u.hidden,
          store: store ? {
            id: store.id,
            type: store.type,
            name: store.name,
            address_notes: store.address_notes,
            address: address ? {
              id: address.id,
              city: address.city,
              street: address.street,
              building: address.building
            } : nil
          }
        }
      end
    }
  end
end
