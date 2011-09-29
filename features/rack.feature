Feature: Implement rack interface

  As a developer
  I want to have a rack handler
  In order to serve rack applications

  Scenario: Serve a one-file rack application
    Given I have a rack application "config.ru"
    And the rack application "config.ru" is running
    When I go to "/"
    Then the response should contain "Rack works"

  Scenario: Serve a rails application
    Given I have a rack application "rails_test/config.ru"
    And the rack application "rails_test/config.ru" is running
    When I go to ""
    Then the response should contain "Yarn Test Blog"
