Feature: Static file requests

  As a web-developer
  I
  Want to be able to serve static file requests

  Scenario: Serve a static file
    Given the file "index.html" exist
    And I start the server on port 8000
    When I go to http://localhost:8000/index.html
    Then the page should contain "Success!"

  # Scenario: Serve an error page if the file does not exist
  #   Given the file "non-existing-index.html" does not exist
  #   And I start the server on port 8000
  #   When I go to http://localhost:8000/non-index.html
  #   Then the page should contain "404 - Page does not exist."
