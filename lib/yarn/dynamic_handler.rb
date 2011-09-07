
module Yarn

  class DynamicHandler < RequestHandler

    include Logging

    def prepare_response
      path = extract_path
      content = read_file path
      
      @response[1]["Content-Type"] = "text/html"

      begin
        response = `ruby #{path}`
      rescue Exception => e
        log "An error occured processing #{path}"
        log e.message
        log e.trace
        serve_500_page
      else
        @response[0] = 200
        @response[2] << response
      end
    end

  end
end
