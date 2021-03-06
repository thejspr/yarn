Feature: Concurrency

  As a developer
  I want to be able to serve multiple requests in parallel
  To increase server performance

  Scenario: Perform two requests in parallel
    Given the server is running
    And a client "A"
    And a client "B"
    When client "A" makes a "1" second request
    And client "B" makes a "0.1" second request
    Then client "B" receives a response before client "A"
