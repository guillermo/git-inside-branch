# encoding: UTF-8
require 'test/unit'
require 'git-inside-branch'
require 'tmpdir'
require 'fileutils'


module Git::Inside::Branch::Assertions

  def assert_git_doesnt_change
    in_new_repo do 
      info = get_git_info()
      yield
      assert_equal get_git_info, info, "The environment changed and it should not."
    end
  end

  def get_git_info
    info = {}
    info["HEAD"] = `git symbolic-ref HEAD 2>&1`.strip
    info["status"] = `git status --porcelain 2>&1`.strip
    info["branch"] = `git branch -a | grep '*' 2>&1`.strip
    info["env"]    = `env 2>&1`.strip
    info
  end


  def in_new_repo
    dir = new_repo
    Dir.chdir(dir) do
      yield dir
    end
  ensure
    remove_repo dir
  end
  
  def new_repo
    dir = Dir.mktmpdir("git-inside-branch_test-repo")
    Dir.chdir(dir) do
      `git init 2>&1`
      `echo Hola > Hello.txt 2>&1`
      `git add Hello.txt 2>&1`
      `git commit -a -m 'initial import' --author 'Guillermo Álvarez <guillermo@cientifico.net>' 2>&1`
      `git checkout -b other_branch 2>&1`
      `git checkout master 2>&1`
      assert `git log 2>&1`.include?("initial import"), "The repository could not be created correctly"
    end
    return dir
  end

  def remove_repo(repo)
    FileUtils.remove_entry_secure repo if File.directory? repo
  end
end

