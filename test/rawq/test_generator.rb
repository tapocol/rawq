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
  end
end

