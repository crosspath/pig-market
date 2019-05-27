class Api::UserAddressDeliveryPointSerializer < Lucky::Serializer
  def initialize(
    @dp : UserAddressDeliveryPoint,
    @with_orders : Bool = true,
    @with_address : Bool = true
  ); end

  def render
    res = {
      id: u.id,
      type: "UserAddressDeliveryPoint",
      user_id: u.user_id,
      hidden: u.hidden,
      address_notes: u.address_notes
    }
    if @with_address
      address = @dp.address
      res[:address] = address ? {
        id: address.id,
        city: address.city,
        street: address.street,
        building: address.building
      } : nil
    end
    if @with_orders
      raise "Not implemented" # TODO
    end

    res
  end
end
