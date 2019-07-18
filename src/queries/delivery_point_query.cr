class DeliveryPointQuery
  def self.select_all(user_id : Int32 | Nil = nil)
    address_dp = UserAddressDeliveryPointQuery.new.preload_address
    store_dp   = UserStoreDeliveryPointQuery.new.preload_store

    if user_id
      address_dp = address_dp.user_id(user_id)
      store_dp   = store_dp.user_id(user_id)
    end

    address_ids = store_dp.map(&.store.try(&.address_id)).uniq.to_a
    addresses = AddressQuery.new.id.in(address_ids).group_by(&.id)

    {address_dps: address_dp, store_dps: store_dp, addresses: addresses}
  end
end
