class Api::Me::Show < BaseApiAction
  get "/api/me" do
    json UserSerializer.new(current_user)
  end
end
