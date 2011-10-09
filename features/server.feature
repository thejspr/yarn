Feature: Server control

  As a developer
  I want to be able to start and stop
  So that I can serve files to the web

  Scenario: Start server
    When I start the server on port 3000
    Then I should see "Server started on port 3000"

  Scenario: Stop server
    Given the server is running
    When I stop the server
    Then I should see "Server stopped"
