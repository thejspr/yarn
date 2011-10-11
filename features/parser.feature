Feature: Parse HTTP requests

  As a web-developer
  I want to be able to parse HTTP requests
  To be able to respond accordingly

  Scenario: Parse HTTP request
    Given a HTTP request "GET /index.html HTTP/1.1\r\nUser-Agent: cucumber\r\n"
    And a parser
    When I feed the request to the parser
    Then the result "method" should be "GET"
    And the result "uri" should include "path" with "/index.html"
    And the result "version" should be "HTTP/1.1"
    And the result "headers" should have "User-Agent" with "cucumber"
    
