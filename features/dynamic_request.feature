Feature: Dynamic request

  As a developer
  I want to be able to serve ruby files
  In order to provide dynamic content

  Background:
    Given the server is running as "dynamic"

  Scenario: Serve a dynamic Ruby file
    Given the file "/app.rb" exist
    When I go to "/app.rb"
    Then the response should contain "Dynamic request complete"

  Scenario: Serve a dynamic Ruby file with parameters
    Given the file "/params.rb" exist
    When I go to "/params.rb?x=200"
    Then the response should contain "param was: 200"
