require_relative "lib/custom_feeds/version"

Gem::Specification.new do |spec|
  spec.name        = "custom_feeds"
  spec.version     = CustomFeeds::VERSION
  spec.authors     = [ "Aung Kyaw Phyo" ]
  spec.email       = [ "kiru.kiru28@gmail.com" ]
  spec.homepage = "https://www.joinpatchwork.org/"
  spec.summary     = "Generate custom timelines."
  spec.description = "Generate custom timelines."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/patchwork-hub/custom_feeds"
  spec.metadata["changelog_uri"] = "TGenerate custom timelines."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2.1"
end
