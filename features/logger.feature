Feature: Logger

  As a developer
  I
  Want to log requests and responses

  Background:
    Given the server is running

  Scenario: Log requests
    Given the file "index.html" exist
    When I go to /index.html
    Then I should see "GET /index.html HTTP/1.1"

  Scenario: Log responses
    Given the file "index.html" exist
    When I go to /index.html
    Then I should see "Served: index.html"

  Scenario: Log debug messages
    When I debug "debug message"
    Then I should see "debug: debug message"
