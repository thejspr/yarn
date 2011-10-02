Feature: Implement rack interface

  As a developer
  I want to have a rack handler
  In order to serve rack applications

  Scenario: Serve a one-file rack application
    Given the rack test app is running
    When I go to "/"
    Then the response should contain "Rack works"

  Scenario: Serve a rails application
    Given the rails test app is running
    When I go to ""
    Then the response should contain "Yarn Test Blog"
