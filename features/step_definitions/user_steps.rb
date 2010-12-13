Given "there are no emails" do
  DatabaseCleaner.clean
end

Given "somebody signed up" do
  DatabaseCleaner.clean
  ComingSoon::User.create(:email => "julian.lieberman@gmail.com",
                          :referer => "http://twitter.com")
end
