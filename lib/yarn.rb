require 'rack/handler/yarn'
require 'rack/handler'

module Yarn

  autoload :Server,           "yarn/server"
  autoload :VERSION,          "yarn/version"
  autoload :RequestHandler,   "yarn/request_handler"
  autoload :RackHandler,      "yarn/rack_handler"
  autoload :DirectoryLister,  "yarn/directory_lister"
  autoload :ErrorPage,        "yarn/error_page"
  autoload :Logging,          "yarn/logging"
  autoload :Parser,           "yarn/parser"
  autoload :Response,         "yarn/response"
  autoload :STATUS_CODES,     "yarn/statuses"

  Rack::Handler.register 'yarn', 'Yarn'

end
