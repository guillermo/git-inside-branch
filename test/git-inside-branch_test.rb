# encoding: UTF-8
#

require "test_helper"

class TestGitInsideBranch < Test::Unit::TestCase
  include Git::Inside::Branch::Assertions

  def test_env_setup_correctly
    assert_git_doesnt_change do
      assert_match /Guillermo.*initial import/m, `git log`
    end
  end

  def test_env_doesnt_change_on_non_existing_branches
    assert_git_doesnt_change do
      Git::Inside::Branch.tempory_checkout("pepe")
    end
  end
  

  def test_env_doesnt_change_on_existing_branch
    assert_git_doesnt_change do
      Git::Inside::Branch.tempory_checkout("other_branch")
    end
  end

  def test_env_doesnt_change_when_doing_operations
    assert_git_doesnt_change do
      Git::Inside::Branch.tempory_checkout("other_branch") do
        assert_match /clean/, `git status`
        assert_match /other_branch/, `git branch -a | grep '*'`
        assert_match /other_branch/i, Dir.pwd
        `echo ¿Qué tal? > Hello2.txt`
        `echo adios >> Hello.txt`
        `git add .`
        `git commit -m "New cambios"`
      end
      assert_no_match /other_branch/i, Dir.pwd
    end
  end

  def test_correct_dir
    assert_git_doesnt_change do

      Git::Inside::Branch.tempory_checkout("other_branch") do
        assert_match /.*\/code\z/, Dir.pwd
      end
      
    end

  end

  def test_changes_are_persistent
    assert_git_doesnt_change do
      Git::Inside::Branch.tempory_checkout("other_branch") do
        `echo Hola2 >> Hello.txt`
        `git add *`
        `git commit -a -m "que pasa tron" `
        assert_match /que pasa tron/, `git log`
      end
      Git::Inside::Branch.tempory_checkout("other_branch") do
        assert_match /que pasa tron/, `git log`
      end

    end
  end

  def test_a_new_branch_is_created_correctly
    assert_git_doesnt_change do
      Git::Inside::Branch.tempory_checkout("new_branch") do
        `echo Hola2 >> Hello.txt`
        `git add *`
        `git commit -a -m "que pasa tron" `
        assert_match /que pasa tron/, `git log`
      end
      Git::Inside::Branch.tempory_checkout("new_branch") do
        assert_match /que pasa tron/, `git log`
      end

    end
  end

end
