Feature: Concurrency

  As a developer
  I want to be able to serve multiple requests in parallel
  To increase server throughput

  Background:
    Given the server is running as "dynamic"

  @wip
  Scenario: Perform two requests in parallel
    Given a client "A"
    And a client "B"
    When client "A" makes a "3" seconds request
    And client "B" makes a "1" second request
    Then client "B" receives a response before client "A"
