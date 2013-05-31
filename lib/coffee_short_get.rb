class CoffeeGetAccess < Sprockets::Processor
  def evaluate(context,locals)
    body = data

    if context.pathname.to_s =~ /coffee/
      require 'pp'
      pp context
      pp locals
      
      body = body.gsub(/@\$(\w+)/) do |str| 
        var = str[2..-1]
        "@get('#{var}')"
      end
      body = body.gsub(/\.\$(\w+)/) do |str| 
        var = str[2..-1]
        ".get('#{var}')"
      end
    end
    
    body
  end
end

module CoffeePreExt
  class << self
    def registered(app)
      puts "registered"
      app.after_configuration do
        sprockets.register_preprocessor 'application/javascript', CoffeeGetAccess
      end
    end
    alias :included :registered
  end
end

::Middleman::Extensions.register :coffee_short_get, CoffeePreExt