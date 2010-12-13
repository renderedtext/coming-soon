Feature: Admin collecting emails
In order to make use of this information
As admin
I should be able to see how many signed up and export emails in a CSV file

  Scenario: Accessing the admin page
    Given somebody signed up
    When I go to the admin page
    Then I should see "1 person signed up"
    And I should see "Download emails in a CSV file"
