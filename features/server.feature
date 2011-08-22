Feature: Server control

  As a developer
  I want to be able to command the server
  So that I can control the server

  Scenario: Start server
    When I start the server on port 3000
    Then I should see "Server started on port 3000"

  Scenario: Stop server
    Given the server is running
    When I stop the server
    Then I should see "Server stopped"

  Scenario: Supply port number when starting the server
    When I start the server on port 4000
    Then I should see "Server started on port 4000"
