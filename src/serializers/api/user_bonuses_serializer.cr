class Api::UserBonusesSerializer < Lucky::Serializer
  def initialize(
    @amount : Int16,
    @bc_earned : Array(BonusChange),
    @bc_used : Tuple(Int32, Int16, Time)
  ); end

  def render
    {
      amount: @amount,
      earned: @bc_earned.map do |u|
        {
          id: u.id,
          change: u.change,
          state: u.state,
          state_name: BonusChange::State.new(u.state).to_s,
          order_id: u.user_orders.first?.try(&.id),
          created_at: u.created_at
        }
      end,
      used: @bc_used.map do |u|
        {
          change: u[1],
          order_id: u[0],
          created_at: u[2]
        }
      end
    }
  end
end
