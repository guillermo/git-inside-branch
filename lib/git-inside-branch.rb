require 'tmpdir'
require 'fileutils'

module Git
  module Inside
    class Branch
     
      def self.tempory_checkout(branch)
        dir = find_git_dir
        return dir unless dir || !block_given?

        new(dir,branch).start do
          yield if block_given?
        end
      end

      def initialize(git_dir, branch)
        @branch, @git_dir = branch, git_dir
      end

      def start
        prepare do |temp_dir|
          Dir.chdir(temp_dir) do
            `git co #{@branch} 2>&1`
            yield
          end
        end
      end

      protected

      def self.find_git_dir
        dir = File.expand_path Dir.pwd

        found = false
        dir = Dir.basename(dir) until(found = File.directory?(File.join(dir,'.git')) || dir == "/")
        
        return found ? File.join(dir,'.git') : false
      end

      def prepare
        in_temp_dir do
          preserve_head do
            set_git_env do |code_dir|
              yield code_dir 
            end
          end
        end
      end

      def in_temp_dir()
        @temp_dir = Dir.mktmpdir(@branch)
        yield 
      ensure 
        FileUtils.remove_entry_secure @temp_dir if File.directory? @temp_dir
      end
      
      def preserve_head(*args)
        old_HEAD_ref = `git symbolic-ref HEAD 2>&1`.strip
        `git symbolic-ref HEAD refs/heads/#{@branch} 2>&1`

        yield *args

      ensure
        `git symbolic-ref HEAD #{old_HEAD_ref} 2>&1` unless old_HEAD_ref.empty?
      end
      
      def set_git_env
        code_dir = File.join(@temp_dir, "code")
        old_env = ENV.dup
        Dir.mkdir(code_dir)

        ENV["GIT_INDEX_FILE"] = File.join(@temp_dir,'index')
        ENV["GIT_WORK_TREE"]  = code_dir
        ENV["GIT_DIR"] = @git_dir 
        yield code_dir
      ensure
        ENV.delete "GIT_INDEX_FILE"
        ENV.delete "GIT_WORK_TREE"
        ENV.delete "GIT_DIR"
      end
      
      def in_git_dir?
        return false if `git status --porcelain 2>&1 2>&1` =~ /^fatal.*/ 
        true
      end


    end
  end
end
