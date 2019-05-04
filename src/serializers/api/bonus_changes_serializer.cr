class Api::BonusChangesSerializer < Lucky::Serializer
  def initialize(@records : Array(BonusChange) | BonusChangeQuery); end

  def render
    @records.map do |u|
      {
        id: u.id,
        order_id: u.order_id,
        bonus_account_id: u.bonus_account_id,
        change: u.change,
        state: u.state,
        state_name: BonusChange::State.new(u.state).to_s
      }
    end
  end
end
