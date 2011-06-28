#!/usr/bin/env ruby

require 'tmpdir'
require 'fileutils'

module Task
  extend self

  def start
    look_for_git_dir

    prepare_git do |temp_dir|
      `git clean -fdx && git co taskwarrior`
      begin
        old_home = ENV["HOME"]
        ENV["HOME"] = temp_dir
        #system("task", *ARGV)
        system( *ARGV)
      ensure
        ENV["HOME"] = old_home
      end

      `find #{temp_dir} | xargs git add `
      `git commit -m "Changes"`
    end

#    create_temp_dir
#    import_files_from_git
#    call_taskwarrior
#    export_files_to_git
#    push_changes    
  end

protected

  def prepare_git
    temp_dir = Dir.mktmpdir("git-task")
    old_HEAD_ref = `git symbolic-ref HEAD`.strip
    `git symbolic-ref HEAD refs/heads/taskwarrior`
    code_dir = File.join(temp_dir, "code")

    Dir.mkdir(File.join(code_dir))

    ENV["GIT_INDEX_FILE"] = File.join(temp_dir,'index')
    ENV["GIT_WORK_TREE"]  = code_dir
    yield code_dir
  ensure 
    `git symbolic-ref HEAD #{old_HEAD_ref}`
    FileUtils.remove_entry_secure temp_dir if File.directory? temp_dir
  end

  def look_for_git_dir
    die("You are not in a git tracked directory!") if `git status --porcelain 2>&1` =~ /^fatal.*/ 
  end


  def die(msg)
    $stderr.puts(msg)
    exit -1
  end
end


Task.start
