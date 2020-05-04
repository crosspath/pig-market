class Home::Index < ApiAction
  get "/" do
    json({
      title: "pig_market",
      url:   "https://github.com/crosspath/pig-market"
    })
  end
end
