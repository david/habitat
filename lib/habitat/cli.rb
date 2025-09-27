require "optparse"

module Habitat
  class CLI
    def initialize(argv)
      parse argv
    end

    def call
      raise "No spec file given" unless @blueprint_path
      raise "#{@blueprint_path} is not a file" unless File.file?(@blueprint_path)

      builder = Spec::Builder.load(@blueprint_path)

      specs =
        if container_id
          builder.specs.filter { |spec| spec.name == container_id }
        else
          builder.specs
        end

      specs.each { |spec| os.sync(spec) }
    end

    private def container_id
      ENV["CONTAINER_ID"]&.to_sym
    end

    private def history
      @history ||= History.new
    end

    private def os
      @os ||=
        if container_id
          OS::ArchLinux.new(Shell::Local.new)
        else
          raise NotImplementedError
        end
    end

    private def parse(argv)
      OptionParser.new { |parser|
        parser.on("-fBLUEPRINT", "--file=BLUEPRINT", "Path to blueprint file") do |path|
          @blueprint_path = path
        end
      }.parse!(argv)
    end
  end
end
