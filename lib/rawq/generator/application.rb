require "shellwords"

class RawQ
  class Generator
    class Application
      class << self
        include Shellwords

        def run!(*arguments)
          options = RawQ::Generator::Options.new(arguments)

          if options[:invalid_option]
            $stderr.puts options[:invalid_option]
            options[:show_help] = true
          end

          if options[:show_help]
            $stderr.puts options.opts
            return 1
          end

          if options[:application_name].nil? || options[:application_name].squeeze.strip == ""
            $stderr.puts "missing application name"
            $stderr.puts options.opts
            return 1
          end

          begin
            generator = RawQ::Generator.new(options)
            generator.run
            return 0
          end
        end
      end
    end
  end
end

