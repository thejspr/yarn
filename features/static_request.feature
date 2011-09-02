Feature: Static file requests

  As a web-developer
  I want to be able to serve static files
  To provide fast content on the Internet

  Background:
    Given the server is running as static

  Scenario: Serve a static html file
    Given the file "index.html" exist
    When I go to "/index.html"
    Then the response should contain "Success!"

  Scenario: Serve an javascript file
    Given the file "jquery.js" exist
    When I go to "/jquery.js"
    Then the response should contain "jQuery JavaScript Library"
    And the response should contain "})(window);"

  Scenario: Show an error message if a resource doesnt exist
    Given the file "non-existent-file.html" does not exist
    When I go to "non-existent-file.html"
    Then the response should contain "404"
    Then the response should contain "File does not exist"
