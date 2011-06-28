# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "git-inside-branch/version"

Gem::Specification.new do |s|
  s.name        = "git-inside-branch"
  s.version     = Git::Inside::Branch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Guillermo Álvarez"]
  s.email       = ["guillermo@cientifico.net"]
  s.homepage    = ""
  s.summary     = %q{git-inside-branch let you inspect and modify other branches without affecting current directory}
  s.description = %q{It set GIT_DIR, GIT_WORK_TREE and GIT_INDEX_FILE and checkout temporarily in a temp directory}

  s.rubyforge_project = "git-inside-branch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "bundler"
end
