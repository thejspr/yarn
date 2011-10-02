Feature: Dynamic request

  As a developer
  I want to be able to serve ruby files
  In order to provide dynamic content

  Background:
    Given the server is running

  Scenario: Serve a dynamic Ruby file
    Given the file "/app.rb" exist
    When I go to "/app.rb"
    Then the response should contain "Dynamic request complete"

  Scenario: Support POST data
    Given the file "/post_app.rb" exist
    When I post "field1" as "value1" to "/test_objects/post_app.rb"
    Then the response should be "Recieved field1=value1"
