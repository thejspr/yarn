require 'yarn/request_handler'
require 'yarn/directory_lister'

module Yarn

  class StaticHandler < RequestHandler

    def prepare_response
      path = extract_path

      if File.directory? path
        serve_directory path
      elsif File.exists?(path)
        serve_file path
      else
        serve_404_page
      end
    end
  end
end
