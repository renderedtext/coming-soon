Feature: Admin collecting emails
In order to make use of this information
As admin
I should be able to see how many signed up and export emails in a CSV file

  Scenario: Accessing the admin page
    Given somebody signed up
    When I go to the admin page
    Then I should see "1 person signed up"
    And I should see "Download emails in a CSV file"

  Scenario: Downloading emails in CSV file
    Given there are no emails
    And "dieter@gmail.com" signed up
    And "karin@gmail.com" signed up
    When I go to the admin page
    And I follow "Download emails in a CSV file"
    Then I should receive CSV file
    And CSV file should contain "dieter@gmail.com"
    And CSV file should contain "karin@gmail.com"
