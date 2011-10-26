require "helper"

class TestGenerator < Test::Unit::TestCase
  context "when setting options" do
    setup do
      @generator = RawQ::Generator.new({:application_name => "RawQorApp"})
    end

    should "set options" do
      assert_equal({:application_name => "RawQorApp"}, @generator.options)
    end

    should "set path" do
      assert_equal ".", @generator.path
    end

    should "set application_name" do
      assert_equal "RawQorApp", @generator.application_name
    end

    should "set default music_dir" do
      assert_equal File.join(@generator.path, "media/music"), @generator.music_dir
    end

    should "set music_dir" do
      generator = RawQ::Generator.new({:application_name => "RawQorApp", :music_dir => "/home/craig/Music"})
      assert_equal "/home/craig/Music", generator.music_dir
    end

    should "set default username" do
      assert_equal "RawQorApp", @generator.username
    end

    should "set username" do
      generator = RawQ::Generator.new({:application_name => "RawQorApp", :username => "username"})
      assert_equal "username", generator.username
    end

    should "set password" do
      assert_equal 8, @generator.password.length
    end
  end
end

