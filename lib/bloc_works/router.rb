module BlocWorks
  class Application
    def controller_and_action(env)
      _, controller, action, _ = env["PATH_INFO"].split("/", 4)
      controller = controller.capitalize
      controller = "#{controller}Controller"

      [Object.const_get(controller), action]
    end

    def fav_icon(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end
    end

    def route(&block)
       @router ||= Router.new
       @router.instance_eval(&block)
    end

    def get_rack_app(env)
       if @router.nil?
         raise "No routes defined"
       end

       if env["PATH_INFO"][-1] == "/" && env["PATH_INFO"].length != 1
         env["PATH_INFO"] = env["PATH_INFO"][0...-1]
       end
       @router.look_up_url(env["PATH_INFO"])
     end
  end

  class Router
     def initialize
       @rules = []
     end

     def map(url, *args)
       options = {}
       options = args.pop if args[-1].is_a?(Hash)
       options[:default] ||= {}

       destination = nil
       destination = args.pop if args.size > 0
       raise "Too many args!" if args.size > 0

       parts = url.split("/")
       parts.reject! { |part| part.empty? }

       parts_array = parts_helper(parts)
       regex = parts_array[1].join("/")
       @rules.push({ regex: Regexp.new("^/#{regex}$"),
                     vars: parts_array[0], destination: destination,
                     options: options })
     end

     def parts_helper(parts)
       vars, regex_parts = [], []
       parts.each do |part|
         case part[0]
         when ":"
           vars << part[1..-1]
           regex_parts << "([a-zA-Z0-9]+)"
         when "*"
           vars << part[1..-1]
           regex_parts << "(.*)"
         else
           regex_parts << part
         end
       end
       return [vars,regex_parts]
     end

     def look_up_url(url)
        @rules.each do |rule|
          rule_match = rule[:regex].match(url)

          if rule_match
            params = params_helper(rule, url)
            if rule[:destination] == nil
              rule[:destination] = "#{params["controller"]}##{params["action"]}"
            end
              return get_destination(rule[:destination], params)
          end
        end
      end

    def params_helper(rule,url)
        options = rule[:options]
        params = options[:default].dup
        rule[:vars].each_with_index do |var, index|
          params[var] = rule[:regex].match(url).captures[index]
        end
        return params
      end

    def get_destination(destination, routing_params = {})
       if destination.respond_to?(:call)
        return destination
      end

      if destination =~ /^([^#]+)#([^#]+)$/
        name = $1.capitalize
        controller = Object.const_get("#{name}Controller")
        return controller.action($2, routing_params)
      end
      raise "Destination no found: #{destination}"
      end

      def resources(resource)
        routes_needed = [["", "books#welcome"],
                        [":controller/:id/:action"],
                        [":controller/:id", default: {"action" => "show"}],
                        [":controller", default: {"action" => "index"}]]

        routes_needed.each do |route|
          map route[0], route[1]
        end

      end
    end
end
