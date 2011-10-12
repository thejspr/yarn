
module Yarn
  # HTML error pages
  module ErrorPage

    # Makes the response a 404 error page
    def serve_404_page
      @response.status = 404
      fn = @request[:uri][:path] if @request
      @response.body = ["<html><head><title>404</title></head><body><h1>File #{fn} does not exist.</h1></body><html>"]
    end

    # Makes the response a 505 error page
    def serve_500_page
      @response.status = 500
      @response.body = ["<h1>Yarn!?</h1>\nA server error occured."]
    end

  end
end
