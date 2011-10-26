require "erb"
require "rawq/version"

class RawQ
  class FileExists < StandardError
  end

  class Generator
    require "rawq/generator/options"
    require "rawq/generator/application"

    attr_accessor :options, :path, :application_name, :music_dir, :username, :password

    def initialize(options = [])
      self.options = options
      self.path, self.application_name = File.split(options[:application_name])
      self.music_dir = options[:music_dir] || File.join(self.path, "media/music")
      self.username = options[:username] || self.application_name
      self.password = (0...8).map{('a'..'z').to_a[rand(26)]}.join
    end

    def run
      create_dirs
      create_files
    end

    def target_dir
      File.join(self.path, self.application_name)
    end

    def template_dir
      File.join(File.dirname(__FILE__), 'templates')
    end

    def create_dirs
      if File.exists?(target_dir)
        raise FileExists, "A directory or file at #{self.path} already exists. Aborted."
      end
      create_dir target_dir
    end

    def create_dir(dir)
      $stdout.puts "\tmkdir\t#{dir}"
      Dir.mkdir dir
    end

    def create_files
      find_templates(".").each do |template|
        next create_dir File.join(target_dir, template) if File.directory?(File.join(template_dir, template))
        create_template template
      end
    end

    def find_templates(pwd)
      templates = []
      Dir.new(File.join(template_dir, pwd)).each do |filename|
        next if [".", ".."].include?(filename)
        templates << File.join(pwd, filename)
        templates = templates + find_templates(File.join(pwd, filename)) if File.directory?(File.join(template_dir, pwd, filename))
      end
      templates
    end

    def render_template(source)
      contents = File.read(File.join(template_dir, source))
      template = ERB.new(contents, nil, "<>")
      template.result(binding)
    end

    def create_template(source)
      target = File.join(target_dir, source)
      if File.extname(source) == ".erb"
        template_result = render_template(source)
        target = File.join(File.dirname(target), File.basename(target, ".erb"))
      else
        template_result = File.read(File.join(template_dir, source))
      end

      $stdout.puts "\tcreate\t#{target}"
      File.open(target, "w") { |file| file.write(template_result) }
    end
  end
end

