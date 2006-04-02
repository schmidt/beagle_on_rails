$__ri18n_source_patterns = ['lib/**/*']

spec = Gem::Specification.new do |s|
  s.name = 'ri18n'
  s.version = s.version = File.read("VERSION").strip
  s.platform = Gem::Platform::RUBY
  s.summary = 'Ruby application internationalization and localization library'
  s.description = <<-EOF
     Ri18n is an internationalization and localization library for Ruby applications.
  EOF
  s.author = 'Denis Mertz'
  s.email = 'dmertz at online dot de'
  s.homepage = 'http://ri18n.berlios.de/'

  s.requirements << 'Rake'
  s.require_path = 'lib'
  s.rubyforge_project = "ri18n"
  
  s.files = $__ri18n_source_patterns.inject([]) { |list, glob|
   list << Dir[glob].delete_if { |path|
      File.directory?(path) 
    }
  }.flatten

end
