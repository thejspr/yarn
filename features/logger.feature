Feature: Logger

  As a developer
  I
  Want to log requests and responses

  Scenario: Log requests
    Given I start the server on port 8000
    And the file "index.html" exist
    When I go to /index.html
    Then I should see "GET /index.html HTTP/1.1"

  Scenario: Log responses
    Given I start the server on port 8000
    And the file "index.html" exist
    When I go to /index.html
    Then I should see "Served: index.html"

  Scenario: Log debug messages
    Given I start the server on port 8000
    When I debug "debug message"
    Then I should see "debug: debug message"
