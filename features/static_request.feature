Feature: Static file requests

  As a web-developer
  I
  Want to be able to serve static file requests

  Scenario: Serve a static file
    Given the file "index.html" exist
    And I start the server on port 8000
    When I visit /index.html
    Then the page should contain "Success!"
