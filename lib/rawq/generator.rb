require "erb"
require "fileutils"
require "rawq/version"

class RawQ
  class FileExists < StandardError
  end

  class Generator
    require "rawq/generator/options"
    require "rawq/generator/application"

    attr_accessor :options, :path, :application_name

    def initialize(options = [])
      self.options = options
      self.path, self.application_name = File.split(options[:application_name])
    end

    def run
      create_files
    end

    def target_dir
      File.join(self.path, self.application_name)
    end

    def template_dir
      File.join(File.dirname(__FILE__), 'templates')
    end

    def create_files
      if File.exists?(target_dir)
        raise FileExists, "A directory or file at #{self.path} already exists. Aborted."
      end
      FileUtils.mkdir target_dir
      $stdout.puts "\tmkdir\t#{target_dir}"

      output_template_to_target "application.rb"
      output_template_to_target "Gemfile"
    end

    def render_template(source)
      contents = File.read(File.join(template_dir, source))
      template = ERB.new(contents, nil, "<>")
      template.result(binding)
    end

    def output_template_to_target(source)
      target = File.join(target_dir, source)
      template_result = render_template(source)

      File.open(target, "w") { |file| file.write(template_result) }
      $stdout.puts "\tcreate\t#{target}"
    end
  end
end

