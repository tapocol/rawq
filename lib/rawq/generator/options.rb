class RawQ
  class Generator
    class Options < Hash
      attr_reader :opts

      def initialize(args)
        super()

        require "optparse"
        @opts = OptionParser.new do |o|
          o.banner = "Usage: #{File.basename($0)} [options] application_name\ne.g. #{File.basename($0)} RawQorApp"

          o.on("-h", "display this help and exit") do
            self[:show_help] = true
          end
        end

        begin
          @opts.parse!(args)
          self[:application_name] = args.shift
        rescue OptionParser::InvalidOption => e
          self[:invalid_option] = e.message
        end
      end
    end
  end
end

