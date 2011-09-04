Feature: Concurrency

  As a developer
  I want to be able to serve multiple requests in parallel
  To increase server throughput

  Background:
    Given the server is running

  Scenario: Perform two requests in parallel
    Given a client "slow"
    And a client "fast"
    When client "slow" makes a "slow" request
    And client "fast" makes a "fast" request
    Then client "fast" receives a response before client "slow"
