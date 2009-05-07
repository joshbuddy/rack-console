require 'lib/rack_console'

use Rack::Console

run Proc.new{|env|
  sleep(env['PATH_INFO'].length.to_f / 10)
  [200, {'Content-type' => 'text/html', 'Content-length' => '2'}, ['hi']]
}

