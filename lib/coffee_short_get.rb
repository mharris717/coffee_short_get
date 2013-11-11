class CoffeeParse
  class << self
    def parse(body)
      body = body.gsub(/@\$(\w+)/) do |str| 
        var = str[2..-1]
        "@get('#{var}')"
      end
      body = body.gsub(/\.\$(\w+)/) do |str| 
        var = str[2..-1]
        ".get('#{var}')"
      end
      body
    end
  end
end

if defined?(Sprockets) && defined?(Sprockets::Processor)
  class CoffeeGetAccess < Sprockets::Processor
    def evaluate(context,locals)
      body = data

      if context.pathname.to_s =~ /coffee/      
        body = CoffeeParse.parse(body)
      end
      
      body
    end

    
  end

  module CoffeePreExt
    class << self
      def registered(app)
        app.after_configuration do
          sprockets.register_preprocessor 'application/javascript', CoffeeGetAccess
        end
      end
      alias :included :registered
    end
  end
end

if defined?(Middleman)
  ::Middleman::Extensions.register :coffee_short_get, CoffeePreExt
end