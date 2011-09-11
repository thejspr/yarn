Feature: Logger

  As a developer
  I want logging functionality
  To be able to debug and monitor server usage

  Background:
    Given the server is running

  Scenario: Log messages
    When I log "log message"
    Then I should see "log message"

  Scenario: Log debug messages
    When I debug "debug message"
    Then I should see "DEBUG: debug message"
