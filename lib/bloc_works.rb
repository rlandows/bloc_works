require_relative "bloc_works/version"
require_relative "bloc_works/dependencies"
require_relative "bloc_works/controller"
require_relative "bloc_works/utility"
require_relative "bloc_works/router"

module BlocWorks
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
         return [404, {'Content-Type' => 'text/html'}, []]
       end
       puts env
       rack_app = get_rack_app(env)
      #  puts rack_app
       rack_app.call(env)
     end
   end
 end

# module BlocWorks
#   class Application
#     def call(env)
#       puts "This is the env #{env["PATH_INFO"]}"
#       if env["PATH_INFO"]== '/'
#           [200, {'Content-Type' => 'text/html'}, ["Hello Blocheads"]]
#       elsif env["PATH_INFO"]== '/favicon.ico'
#         return fav_icon(env)
#       else
#           body = controller_and_action(env)
#           last_one = body[1].to_sym
#           controller = body[0].new(env)
#           puts "#{body[0]} and this #{body[1]}"
#           # puts controller.send(body[1])
#          if puts controller.has_response?
#          status, header, response = controller.get_response
#          [status, header, [response.body].flatten]
#        else
#           [200, {'Content-Type' => 'text/html'}, controller.send(body[1])]
#        end
#       end
#     end
#   end
# end
