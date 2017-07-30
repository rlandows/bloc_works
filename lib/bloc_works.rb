require_relative "bloc_works/version"
require_relative "bloc_works/dependencies"
require_relative "bloc_works/controller"
require_relative "bloc_works/utility"
require_relative "bloc_works/router"


module BlocWorks
  class Application
    def call(env)
      puts "This is the env #{env["PATH_INFO"]}"
      if env["PATH_INFO"]== '/'
          [200, {'Content-Type' => 'text/html'}, ["Hello Blocheads"]]
      elsif env["PATH_INFO"]== '/favicon.ico'
        return fav_icon(env)
      else
          # puts "this is body 1 #{body[0]}"
          # puts "this is body 2 #{body[1]}"
          puts body = controller_and_action(env)
          last_one = body[1].to_sym
          [200, {'Content-Type' => 'text/html'}, [body[0].new(env).send(body[1])]]
      end
    end
  end
end
