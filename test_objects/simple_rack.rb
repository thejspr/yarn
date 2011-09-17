# app = Rack::Builder.new {
#   use Rack::CommonLogger
#   use Rack::ShowExceptions
#   map "/lobster" do
#     use Rack::Lint
#     run Rack::Lobster.new
#   end
# }
# 
app =  proc do |env|
  [200, { 'Content-Type' => 'text/html' }, ['rack works']]
end
