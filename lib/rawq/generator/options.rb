class RawQ
  class Generator
    class Options < Hash
      attr_reader :opts

      def initialize(args)
        super()

        require "optparse"
        @opts = OptionParser.new do |o|
          o.banner = "Usage: #{File.basename($0)} [options] application_name\ne.g. #{File.basename($0)} RawQorApp"

          o.on("--music-dir [MUSIC_DIR]", "set your music directory") do |music_dir|
            self[:music_dir] = music_dir
          end

          o.separator ""

          o.on("--username [USERNAME]", "set your username") do |username|
            self[:username] = username
          end

          o.separator ""

          o.on_tail("-h", "--help", "display this help and exit") do
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

