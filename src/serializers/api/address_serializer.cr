class Api::AddressSerializer < Lucky::Serializer
  alias DeliveryPoints = UserAddressDeliveryPointQuery | Array(UserAddressDeliveryPoint)
  alias ResultValue = Int32 | String | Api::StoresSerializer
    | Array(Api::UserAddressDeliveryPointSerializer)

  def initialize(
    @address : Address,
    @stores : StoreQuery | Array(Store) | Nil = nil,
    @delivery_points : DeliveryPoints | Nil = nil
  ); end

  def render
    attributes = Hash(Symbol, ResultValue){
      id: @address.id,
      city: @address.city,
      street: @address.street,
      building: @address.building
    }

    if @stores
      attributes[:stores] = Api::StoresSerializer.new(@stores)
    end

    if @delivery_points
      attributes[:delivery_points] = @delivery_points.map do |u|
        Api::UserAddressDeliveryPointSerializer.new(u)
      end
    end

    attributes
  end
end
