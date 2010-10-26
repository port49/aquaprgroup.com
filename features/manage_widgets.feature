Feature: Manage Widgets
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
  
  Scenario: Create Widget
    When I follow "New"
    And I fill in "widget_name" with "title 1"
    And I fill in "widget_description" with "body 1"
    And I press "Create"
    Then I should see "title 1 created."
    Then I should see "title 1"
    And I should see "body 1"

  Scenario: Read Widget
    When I follow "title 2"
    Then I should see "title 2"
    And I should see "body 2"

  Scenario: Update Widget
    When I follow "title 2"
    And I fill in "widget_name" with "title two"
    And I fill in "widget_description" with "body two"
    And I press "Save"
    Then I should see "title two updated."
    Then I should see "title two"
    And I should see "body two"

  Scenario: Delete Widget
    When I follow "title 3"
    And I follow "Delete..."
    Then I should see "title 3 deleted."
    Then I should have 3 widgets

  Scenario: Publish Widget
    When I follow "title 2"
    And I press "Publish"
    Then I should see "title 2 published."
    And widget "title 2" should be published

