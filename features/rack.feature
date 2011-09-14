Feature: Implement rack interface

  As a developer
  I want to have a rack handler
  In order to serve rack applications

  @wip
  Scenario: Serve a one-file rack application
    Given I have a rack application "simple_rack.rb"
    And the server is running as "rack"
    When I go to "/"
    Then the response should contain "rack works"
