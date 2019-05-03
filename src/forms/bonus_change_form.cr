class BonusChangeForm < BonusChange::BaseForm
  fillable bonus_account_id, order_id, change, state
end
