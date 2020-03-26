class Api::AddressSerializer < BaseSerializer
  alias DeliveryPoints = UserAddressDeliveryPointQuery | Array(UserAddressDeliveryPoint)

  def initialize(
    @address : Address,
    @stores : StoreQuery | Array(Store) | Nil = nil,
    @delivery_points : DeliveryPoints | Nil = nil
  ); end

  def render
    attributes = Hash(Symbol, ResultValue){
      :id => @address.id,
      :city => @address.city,
      :street => @address.street,
      :building => @address.building
    }

    if @stores
      items = Api::StoreSerializer.for_collection(@stores.not_nil!)
      attributes[:stores] = items
    end

    if @delivery_points
      attributes[:delivery_points] = @delivery_points.not_nil!.map do |u|
        Api::UserAddressDeliveryPointSerializer.new(u).as(Lucky::Serializer)
      end
    end

    attributes
  end
end
