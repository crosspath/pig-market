class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    h1 "Sign In"
    render_sign_in_form(@operation)
  end

  private def render_sign_in_form(op)
    form_for SignIns::Create do
      sign_in_fields(op)
      submit "Sign In", flow_id: "sign-in-button"
    end
    link "Sign up", to: SignUps::New
  end

  private def sign_in_fields(op)
    mount Shared::Field.new(op.login), &.text_input(autofocus: "true")
    mount Shared::Field.new(op.password), &.password_input
  end
end
