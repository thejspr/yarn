require 'pry'
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
  autoload :ParsletParser,    "yarn/parslet_parser"
  autoload :Response,         "yarn/response"
  autoload :STATUS_CODES,     "yarn/statuses"
  autoload :Worker,           "yarn/worker"
  autoload :WorkerPool,       "yarn/worker_pool"

  Rack::Handler.register 'yarn', 'Yarn'

end
