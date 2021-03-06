require 'popen4'
require 'highline/import'

module Collector
  class Command

    # Perform a command line process and read it's output.
    def execute(cmd, &block)
      output = nil
      error  = nil

      say("<%= color('[stdout]:', :green) %> Parsing command '#{cmd}'")
      status = POpen4.popen4(cmd) do |stdout, stderr|
        yield(stdout.read.strip, stderr.read.strip)
      end
    end

    # JSON output consists of keywords that are not used 1:1. These
    # are converted to correct boolean values and method definitions.
    def json_parse(info)
      begin
        info.gsub!('"update"', '"has_update"')
        info.gsub!('"none"', 'false')
        info.gsub!('"available"', 'true')
        info.gsub!('"security"', 'true')
        output = JSON.parse(info)
      rescue JSON::ParserError
        say("<%= color('[stderr]:', :red) %> Error parsing json in #{current.dir}")
        output = nil
      end
    end

  end

  class WpCliErrorException < Exception; end;
end