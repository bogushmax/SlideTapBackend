require './application'
SlideTapBackend::Application.initialize!

# Development middlewares
if SlideTapBackend::Application.env == 'development'
  use AsyncRack::CommonLogger

  # Enable code reloading on every request
  use Rack::Reloader, 1

  # Serve assets from /public
  # use Rack::Static, :urls => ["/javascripts"], :root => SlideTapBackend::Application.root(:public)
end

# JSON response support
use AsyncRack::ContentType, 'application/json'

# JSON request parameters support
MultiJson.engine = :yajl
use Rack::Parser

# Running thin :
#
#   bundle exec thin --max-persistent-conns 1024 --timeout 0 -R config.ru start
#
# Vebose mode :
#
#   Very useful when you want to view all the data being sent/received by thin
#
#   bundle exec thin --max-persistent-conns 1024 --timeout 0 -V -R config.ru start
#
run SlideTapBackend::Application.routes
