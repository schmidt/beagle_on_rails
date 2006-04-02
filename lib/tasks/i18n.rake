require 'rubygems'
require 'gettext'
require 'i18nservice'
require 'config/i18nconfig'

# ri18n Einbindung
Rake::GettextTask.new do |t|
    t.new_langs = ['de', 'en', 'fr', 'es']
    t.source_files = ['app/**/*.rb','app/**/*.rhtml','lib/**/*', 'config/*.rb']
    t.verbose = true
end
