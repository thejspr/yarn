Feature: Concurrency

  As a developer
  I want to be able to serve multiple requests in parallel
  To increase server throughput

  Background:
    Given the server is running

  Scenario: Perform two requests in parallel
    Given a client A
    And a client B
    When client A makes a slow request
    And client B makes a fast request
    Then client B should receive a response
