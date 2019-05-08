class Api::AddressSerializer < Lucky::Serializer
  def initialize(@address : Address, @recipient : Bool = false); end

  def render
    attributes = {
      id: @address.id,
      city: @address.city,
      street: @address.street,
      building: @address.building,
      additional: @address.additional,
      hidden: @address.hidden
    }

    if @recipient
      attributes = attributes.merge({
        recipient: {
          id: @address.recipient_id,
          type: @address.recipient_type
        }
      })
    end

    attributes
  end
end
