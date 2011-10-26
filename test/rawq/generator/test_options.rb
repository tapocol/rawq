require "helper"

class TestOptions < Test::Unit::TestCase
  def setup_options(*arguments)
    @options = RawQ::Generator::Options.new(["application_name"] + arguments)
  end

  context "default options" do
    setup do
      setup_options
    end

    should "have application name" do
      assert_equal "application_name", @options[:application_name]
    end

    should "not have invalid_option" do
      assert !@options[:invalid_option]
    end
  end

  context "-h" do
    should "show help" do
      setup_options "-h"
      assert @options[:show_help]
    end
  end

  context "--help" do
    should "show help" do
      setup_options "--help"
      assert @options[:show_help]
    end
  end

  context "--music-dir" do
    should "set music_dir" do
      setup_options "--music-dir", "/home/craig/Music"
      assert_equal "/home/craig/Music", @options[:music_dir]
    end
  end

  context "--username" do
    should "set username" do
      setup_options "--username", "username"
      assert_equal "username", @options[:username]
    end
  end

  context "--not-option" do
    should "store invalid_option if incorrect argument" do
      setup_options "--not-option"
      assert @options[:invalid_option]
    end
  end
end

