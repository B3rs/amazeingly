Gem::Specification.new do |s|
  s.name        = 'amazeingly'
  s.version     = '0.0.1'
  s.date        = '2016-11-07'
  s.summary     = 'An A-Maze-ingly gem'
  s.description = 'A simple Ruby gem that shows a valid path between a set of rooms in order to collect some objects'
  s.authors     = ['Marco Bersani']
  s.email       = 'marcobers@hotmail.it'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- test/*`.split("\n")

  s.executables << 'amazeingly'

  s.homepage    = 'https://github.com/B3rs/amazeingly'

  s.license = 'MIT'

  s.add_dependency('minitest', '~> 5.4')
  s.add_dependency('minitest-reporters', '~> 1.1')
  s.add_development_dependency('rubocop', '~> 0.45')
  s.add_development_dependency('guard', '~> 2.14')
  s.add_development_dependency('guard-minitest', '2.4.6')
end
