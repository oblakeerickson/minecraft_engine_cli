Gem::Specification.new do |s|
  s.name = 'minecraft_engine_cli'
  s.version = '0.0.0'
  s.summary = 'Minecraft Engine CLI'
  s.description = 'A command line tool for creating minecraft servers'
  s.authors = ['Blake Erickson']
  s.email = 'o.blakeerickson@gmai.com'
  s.files = ['lib/minecraft_engine_cli.rb']
  s.executables = ['minecraft_engine_cli']
  s.homepage = 'https://github.com/oblakeerickson/minecraft_engine_cli'
  s.license = 'MIT'
  s.add_dependency 'droplet_kit', '~> 2.2'
  s.add_dependency 'dropbox_api', '~> 0.1'
end
