require 'gserver'
require 'thread'
require 'json'

module Rack

  class Console
    
    @@stats = Hash.new{|h,k| h[k] = []}
    @@gather_stats = false
    @@watch = false
    @@watch_queue = []
    
    Watch = Struct.new(:time, :env, :response)
    
    def self.watch_queue
      @@watch_queue
    end
    
    def self.gather_stats
      @@gather_stats
    end
    
    def self.gather_stats=(gather_stats)
      @@gather_stats = gather_stats
    end
    
    def self.watch
      @@watch
    end
    
    def self.watch=(watch)
      @@watch = watch
    end
    
    def self.stats
      @@stats
    end
    
    def initialize(app)
      @app = app
      @handler = Handler.new
    end
    
    def call(env)
      if resp = @handler.handle(env)
        [200, {'Content-length' => resp.size.to_s, 'Content-type' => 'text/x-json'}, [resp]]
      else
        @@gather_stats || @@watch ? call_with_timing(env) : _call(env)
      end
    end

    def call_with_timing(env)
      start_time = Time.new.to_f
      response = @app.call(env)
      time_run = Time.new.to_f - start_time
      if @@gather_stats
        @@stats[env['PATH_INFO']] << time_run
      end
      if @@watch
        @@watch_queue << Watch.new(time_run, env, response)
      end
      response
    end
    
    def _call(env)
      @app.call(env)
    end
    
    class Handler
      
      def handle(env)
        
        p env
        if (cmd = env['HTTP_X_RACK_CONSOLE']) && ['gather', 'ditch', 'clear', 'watch', 'stats', 'stop'].include?(cmd)
          send(cmd.to_sym)
        end
      end

      def stats
        Rack::Console.stats.to_json
      end
      
      def gather
        Rack::Console.gather_stats = true
        'true'
      end
      
      def ditch
        Rack::Console.gather_stats = false
        clear
      end
      
      def clear
        Rack::Console.stats.clear
        'true'
      end
      
      def watch
        Rack::Console.watch = true
        events = Rack::Console.watch_queue.map{|w| w.to_a}.to_json
        Rack::Console.watch_queue.clear
        puts "events: #{events}"
        events
      end
      
      def stop
        Rack::Console.watch = false
        'true'
      end
      
      def start
        Rack::Console.watch = true
        'true'
      end
      
    end

  end
end

