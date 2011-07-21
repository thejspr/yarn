Feature: Logger

  As a developer
  I
  Want to log requests and responses

  @wip
  Scenario: Log requests
    Given I start the server on port 8000
    And I go to index.html
    Then the log should contain "GET /index.html HTTP/1.1"

  Scenario: Log responses
    Given I start the server on port 8000
    And I go to index.html
    Then the log should contain "<- HTTP/1.1 200 OK /index.html"

  Scenario: Log debug messages
    Given I start the server on port 8000
    And I debug "debug message"
    Then The log should contain "debug: debug message"
