class SpecialApi::UserBonusesSerializer < Lucky::Serializer
  def initialize(
    @amount : Int16,
    @earned : Array(UserOrder) | UserOrderQuery,
    @used : Array(UserOrder) | UserOrderQuery
  ); end

  def render
    {
      amount: @amount,
      earned: @earned.map do |u|
        state = UserOrder::EarnedBonusesState.from_value?(u.earned_bonuses_state)
        {
          order_id: u.id,
          bonuses: u.earned_bonuses,
          state: u.earned_bonuses_state,
          state_name: state.try(&.to_s)
        }
      end,
      used: @used.map do |u|
        {
          order_id: u.id,
          bonuses: u.used_bonuses
        }
      end
    }
  end
end
