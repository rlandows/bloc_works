require "erubis"

module BlocWorks
  class Controller
    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
       @routing_params = routing_params
       text = self.send(action)
       if has_response?
         rack_response = get_response
         [rack_response.status, rack_response.header, [rack_response.body].flatten]
       else
         [200, {'Content-Type' => 'text/html'}, [text].flatten]
       end
     end

     def self.action(action, response = {})
       proc { |env| self.new(env).dispatch(action, response) }
     end

    def request
       @request ||= Rack::Request.new(@env)
    end

    def params
       request.params.merge(@routing_params)
    end

    def response(text, status = 200, headers = {})
      raise "Cannot respond multiple times" unless @response.nil?
      @response = Rack::Response.new([text].flatten, status, headers)
    end

    def render(*args)
      if args[0].is_a? Hash
        controller_action = @routing_params["action"].to_sym
        args.unshift(controller_action)
        response(create_reponse_array(*args))
      else
       response(create_reponse_array(*args))
      end
     end

     def redirect_to(*args)
      if args[0].is_a? Hash
        controller_action = @routing_params["action"].to_sym
        args.unshift(controller_action)
        response(create_reponse_array(*args))
      else
       response(create_reponse_array(*args))
      end
     end

     def get_response
      @response
    end

    def has_response?
       !@response.nil?
     end

    def create_reponse_array(view, locals = {})
       filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
       template = File.read(filename)
       eruby = Erubis::Eruby.new(template)
       eruby.result(locals.merge(env: @env))
     end

     def controller_dir
       klass = self.class.to_s
       klass.slice!("Controller")
       BlocWorks.snake_case(klass)
     end
  end
end
