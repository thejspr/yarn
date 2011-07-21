Feature: Server control

  As a developer
  I want to start the server
  So that I can serve content on the web

  Scenario: Start server
    When I start the server on port 8000
    Then I should see "Server started on port 8000"

  Scenario: Stop server
    Given the server is running
    When I stop the server
    Then I should see "Server stopped"

  Scenario: Supply port number when starting the server
    When I start the server on port 4000
    Then I should see "Server started on port 4000"
