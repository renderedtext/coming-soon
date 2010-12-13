Feature: Signing up with email
In order to find out when this app is launched
As a user
I should be able to provide my email and leave safe

  Scenario: Opening the home page
    When I go to the home page
    Then I should see "Enter your email address"

  Scenario: Providing an email
    When I go to the home page
    And I fill in "email" with "ty.coon@hotmail.com"
    And I press "Notify me"
    Then I should see "Thank you"

  Scenario: Entering blank email
    When I go to the home page
    And I press "Notify me"
    Then I should see "no point"

  Scenario: Entering invalid email
    When I go to the home page
    And I fill in "email" with "ty.coonhotmail.com"
    And I press "Notify me"
    Then I should see "odd"

  Scenario: Entering same email twice
    Given there are no emails
    When I go to the home page
    And I fill in "email" with "ty.coon@hotmail.com"
    And I press "Notify me"
    And I go to the home page
    And I fill in "email" with "ty.coon@hotmail.com"
    And I press "Notify me"
    Then I should see "already on the list"
