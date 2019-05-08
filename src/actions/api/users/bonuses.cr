class Api::Users::Bonuses < ApiAction
  get "/api/users/:user_id/bonuses" do
    ba = BonusAccountQuery.new.user_id(user_id).preload_bonus_changes.results

    if ba.empty?
      response_success(amount: nil, bonus_changes: [] of String)
    else
      records = ba.flat_map(&.bonus_changes).to_a
      sum_amount = ba.sum(&.amount)
      result = Api::BonusChangesSerializer.new(records)

      response_success(amount: sum_amount, bonus_changes: result)
    end
  rescue e
    response_error(500, e)
  end
end
