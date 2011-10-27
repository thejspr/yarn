Feature: Static file requests

  As a web-developer
  I want to be able to serve static files
  To provide fast content on the Internet

  Background:
    Given the server is running

  Scenario: Serve a static html file
    Given the file "index.html" exist
    When I go to "/index.html"
    Then the response should contain "Success!"

  Scenario: Serve an javascript file
    Given the file "jquery.js" exist
    When I go to "/jquery.js"
    Then the response should contain "jQuery JavaScript Library"
    And the response should contain "})(window);"
