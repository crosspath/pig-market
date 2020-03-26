class Me::ShowPage < MainLayout
  def content
    h1 "This is your profile"
    h3 "Login:  #{@current_user.login}"
    helpful_tips
  end

  private def helpful_tips
    h3 "Next, you may want to:"
    ul do
      li { link_to_authentication_guides }
      li "Modify this page: src/pages/me/show_page.cr"
      li "Change where you go after sign in: src/actions/home/index.cr"
    end
  end

  private def link_to_authentication_guides
    link "Check out the authentication guides",
      to: "https://luckyframework.org/guides/authentication"
  end
end