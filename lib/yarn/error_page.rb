
module Yarn
  module ErrorPage

    def serve_404_page
      @response[0] = 404
      @response[2] = ["<html><head><title>404</title></head><body><h1>File does not exist.</h1></body><html>"]
    end

    def serve_500_page
      @response[0] = 500
      @response[2] = ["<h1>Yarn!?</h1>\nA server error occured."]
    end

  end
end
