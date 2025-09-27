require "fileutils"

module Habitat
  class History
    def initialize
      ensure_data_dir
    end

    def first
      item = items.first

      Spec.new(item) if item
    end

    def <<(spec)
      raise IllegalArgumentError unless spec.is_a?(Spec)

      return if spec == first

      snapshot_name = Time.now.strftime("%Y%m%d%H%M%S.yaml")
      snapshot_path = File.join(data_dir, snapshot_name)

      spec.write(snapshot_path)

      self
    end

    private def items
      Dir[File.join(ensure_data_dir, "*")].sort
    end

    private def data_dir
      File.join(ENV["XDG_DATA_HOME"] || File.join(ENV["HOME"], ".local/share"), "habitat")
    end

    private def ensure_data_dir
      FileUtils.mkdir_p(data_dir)
    end
  end
end
