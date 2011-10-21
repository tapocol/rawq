require "helper"

class TestApplication < Test::Unit::TestCase
  def run_application(*arguments)
    original_stdout = $stdout
    original_stderr = $stderr

    fake_stdout = StringIO.new
    fake_stderr = StringIO.new

    $stdout = fake_stdout
    $stderr = fake_stderr

    result = nil
    begin
      result = RawQ::Generator::Application.run!(*arguments)
    ensure
      $stdout = original_stdout
      $stderr = original_stderr
    end

    @stdout = fake_stdout.string
    @stderr = fake_stderr.string

    result
  end

  def stub_options(options = {})
    stub(options).opts { 'Usage:' }

    options
  end

  def self.should_exit_with_code(code)
    should "exit with code #{code}" do
      assert_equal code, @result
    end
  end

  context "show help when invalid_option is set" do
    setup do
      stub(RawQ::Generator::Application).build_opts do
        stub_options(:invalid_option => "Invalid Option!")
      end

      stub(RawQ::Generator).new { raise "Should not create a new generator." }

      assert_nothing_raised do
        @result = run_application("--invalid-option")
      end
    end

    should_exit_with_code 1

    should "puts error message" do
      assert_match "--invalid-option", @stderr
    end

    should "puts Usage" do
      assert_match "Usage:", @stderr
    end

    should "not display anything to stdout" do
      assert_equal "", @stdout.squeeze.strip
    end
  end

  context "show help when missing a application name" do
    setup do
      stub(RawQ::Generator::Application).build_opts do
      end

      stub(RawQ::Generator).new { raise "Should not create a new generator." }

      assert_nothing_raised do
        @result = run_application()
      end
    end

    should_exit_with_code 1

    should "puts error message" do
      assert_match "missing application name", @stderr
    end

    should "puts Usage" do
      assert_match "Usage:", @stderr
    end

    should "not display anything to stdout" do
      assert_equal "", @stdout.squeeze.strip
    end
  end

  context "when options indicate help usage" do
    setup do
      stub(RawQ::Generator::Application).build_opts do
        stub_options(:show_help => true)
      end

      stub(RawQ::Generator).new { raise "Should not create a new generator." }

      assert_nothing_raised do
        @result = run_application("-h")
      end
    end

    should_exit_with_code 1

    should "should puts Usage" do
      assert_match "Usage:", @stderr
    end

    should "not display anything to stdout" do
      assert_equal "", @stdout.squeeze.strip
    end
  end
end

