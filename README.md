# git-inside-branch

git-inside-branch allows you to inspect and modify another branch in a temporarily directory without affecting current working tree.
[![Build Status](https://secure.travis-ci.org/guillermo/git-inside-branch.png)](http://travis-ci.org/guillermo/git-inside-branch)

[![endorse](http://api.coderwall.com/guillermo/endorsecount.png)](http://coderwall.com/guillermo)


# Usage

## From command line

    git inside-branch doc_branch bash

This will checkout doc_branch and run bash. Then you edit your docs with vim or emacs, commit the results and exit bash.

    git inside-branch gh_pages "cp $HOME/projects/my_proj/rdoc . && git add . && git commit -am 'Doc updates' && git push"


## From ruby

    Git::Inside::Branch.tempory_checkout("gh_pages") do
      `cp $HOME/projects/my_lib/rdoc .`
      `git commit -a -m 'Doc updates' && git push`
    end

I think is easy.

# Documentation

* Git::Inside::Branch.tempory_checkout( *branch_name*, *&block* )

  Run the code passed in the block in another temporarily checkouted directory from the branch __branch_name__

# AUTHOR

 * Guillermo Álvarez <guillermo@cientifico.net>


# LICENSE


Copyright (c) 2011, Guillermo Álvarez <guillermo@cientifico.net>
All rights reserved.

"THE BEER-WARE LICENSE" (Revision 42):
<guillermo@cientifico.net> wrote this file. As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return Guillermo Álvarez.


