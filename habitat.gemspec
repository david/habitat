# frozen_string_literal: true

require_relative "lib/habitat/version"

Gem::Specification.new do |spec|
  spec.name = "habitat"
  spec.version = Habitat::VERSION
  spec.authors = ["David Leal"]
  spec.email = ["293+david@users.noreply.github.com"]

  spec.summary = "Declarative installations."
  spec.description = "Declarative installations."
  spec.homepage = "https://github.com/david/habitat"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/david/habitat"
  spec.metadata["changelog_uri"] = "https://github.com/david/habitat/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "optparse", "~> 0.5"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
