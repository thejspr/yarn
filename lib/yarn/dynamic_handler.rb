module Yarn

  class ProcessingError < StandardError; end

  class DynamicHandler < RequestHandler

    include Logging

    def prepare_response
      path = extract_path

      @response.headers["Content-Type"] = "text/html"

      begin
        if File.directory? path
          serve_directory path
        elsif File.exists?(path)
          if path =~ /.*\.rb$/
            @response.body << execute_script(path)
            @response.status = 200
          else
            serve_file(path)
          end
        else
          serve_404_page
        end
      rescue ProcessingError
        log "An error occured processing #{path}"
        serve_500_page
      end
    end

    def execute_script(path)
      response = `ruby #{path}`
      if !! ($?.to_s =~ /1$/)
        raise ProcessingError
      else
        response
      end
    end
  end
end
