Given "there are no emails" do
  DatabaseCleaner.clean
end

Given "somebody signed up" do
  DatabaseCleaner.clean
  ComingSoon::User.create(:email => "julian.lieberman@gmail.com",
                          :referer => "http://twitter.com")
end

Given /^"([^"]*)" signed up$/ do |email|
  ComingSoon::User.create(:email => email)
end

Then /^I should receive CSV file$/ do
  page.response_headers["Content-Type"].should == "text/csv"
end

Then /^CSV file should contain "([^"]*)"$/ do |email|
  emails = FasterCSV.parse(page.body)
  emails.should include [email]
end
