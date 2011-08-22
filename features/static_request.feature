Feature: Static file requests

  As a web-developer
  I want to be able to serve static files
  To provide fast content on the Internet

  Background:
    Given the server is running

  Scenario: Serve a static file
    Given the file "index.html" exist
    When I visit index.html
    Then the page should contain "Success!"
