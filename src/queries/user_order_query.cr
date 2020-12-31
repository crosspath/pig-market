require "../models/user_order.cr"
require "./mixins/polymorphic_where.cr"

class UserOrderQuery < UserOrder::BaseQuery
  include PolymorphicWhere

  def delivery_point(address : Array(Int32), store : Array(Int32))
    w = [] of Tuple(String, Array(Int32))
    w << {UserAddressDeliveryPoint.name, address} unless address.empty?
    w << {UserStoreDeliveryPoint.name, store} unless store.empty?

    query = self

    w.each_with_index do |(type, ids), i|
      if i == 0
        query = query.polymorphic_where_in(:delivery_point, type, ids)
      else
        query = query.or(&.polymorphic_where_in(:delivery_point, type, ids))
      end
    end

    query
  end
end
