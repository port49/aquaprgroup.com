Feature: View MRSS Feeds
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Background:
    Given the following widgets:
      |name   |description|
      |title 1|body 1     |
      |title 2|body 2     |
      |title 3|body 3     |
      |title 4|body 4     |
    And I am on the widgets page
  
  Scenario: View Home Page
    When I follow "New"
    And I fill in "widget_name" with "title 1"
    And I fill in "widget_description" with "body 1"
    And I press "Create"
    Then I should see "title 1 created."
    Then I should see "title 1"
    And I should see "body 1"

