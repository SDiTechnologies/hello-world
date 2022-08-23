### A Logical Approach to Project Management Using Git and Git Flow
---
### Overview:

  - Table of Contents:
    1. git flow
    1. git


  - Sources:
    1. [git flow cheatsheet](https://danielkummer.github.io/git-flow-cheatsheet/)
    1. [git cheatsheet](https://www.git-tower.com/blog/git-cheat-sheet/)
---

## Git Flow

### Basic Usage
```bash
git flow [init|feature|release|hotfix] [start|finish|publish|pull] [NAME]
```

#### Git Flow Basics
1. Install git-flow using instructions from source
1. **Initialize** git-flow project:
```bash
git flow init
```
1. **Features**:
```bash
# start
git flow feature start FEATURE
# finish
git flow feature finish FEATURE
# publish
git flow feature publish FEATURE
# get
git flow feature pull origin FEATURE
# track
git flow feature track FEATURE
```
  ###### ***completion***:
    - merges the feature branch into develop
    - switches back to the develop branch
1. **Releases**:
```bash
# start
git flow release start RELEASE [BASE](OPTIONAL)
# publish
git flow release publish RELEASE
# track remote
git flow release track RELEASE
# finish
git flow release finish RELEASE
# push tags
git push origin --tags
```
  ###### ***completion***:
    - merges the release branch into main
    - tags the release with its name
    - back-merges the release into develop
    - removes the release branch
1. **Hotfixes**
```bash
# start
git flow hotfix start VERSION [BASE](OPTIONAL)
# finish
git flow hotfix finish VERSION
```
  ###### ***completion***:
    - merges the hotfix back into develop and master
    - tags main merge with the hotfix version
---

## Git

**NOTE**: git flow is preferred for interacting with repositories, but git may still be used if issues arise or other one-offs

### Basic Usage
```bash
git [init|branch|checkout|clone|status|diff|log||add|commit|push|pull|fetch] -m COMMIT_MESSAGE -d DELETE_BRANCH
```
#### Git Basics
1. **Initialize**
  - Create
```bash
git init
# or
git flow init
```
  - Clone from existing
```bash
# using https
git clone https://github.com/user/git-repository.git
# using ssh
git clone git@github.com:user/git-repository.git
# using ssh with ~/.ssh/config
git clone user@host:user/git-repository.git
# alternatively, on a local network
git clone ssh://user@domain.com/repo.git
```
1. **Local Changes**
```bash
# changed files in working directory
git status
# list changes to tracked files
git diff
# add all current changes to next commit
git add .
# add some changes in <file> to the next commit
git add -p <file>
# commit all local changes in tracked files
# if MESSAGE is not provided; you will be prompted
git commit -a -m "MESSAGE"
# bare commit
git commit
# change last commit
# WARNING: Don't amend published commits
git commit --amend
```
1. **Commit History**
```bash
# show all commits starting with the newest
git log
# show changes over time for a specified <file>
git log -p <file>
# show who changed what and when in <file>
git blame <file>
```
1. **Branches & Tags**
```bash
# list all existing branches
git branch -av
# list local branches
git branch -l
# switch HEAD <branch>
git checkout <branch>
# create <new-branch> based on current HEAD
git branch <new-branch>
# create a new tracking branch based on a <remote/ branch>
git checkout --track <remove/branch>
# delete local <branch>
git branch -d <branch>
# mark the current commit with a <tag-name>
git tag <tag-name>
```
1. **Update & Publish**
```bash
# list all currently configured remotes
git remote -v
# show information about a <remote>
git remote show <remote>
# add new <remote>
git remote add <shortname> <url>
# Download all changes from <remote>, but don't integrate into HEAD
git fetch <remote>
# Download changes and directly merge/integrate into HEAD
git pull <remote> <branch>
# publish local changes on a <remote>
git push <remote> <branch>
# delete a branch on the remote
git branch -dr <remote/branch>
# publish tags
git push --tags
```
1. **Merge & Rebase**
```bash
# merge <branch> into current HEAD
git merge <branch>
# rebase current HEAD into <branch>
# WARNING: Don't rebase published commits
git rebase <branch>
# abort a rebase
git rebase --abort
# continue a rebase after resolving conflicts
git rebase --continue
# use configured merge tool to solve conflicts
git mergetool
# use editor to manually solve conflicts and (after resolving) mark file as resolved
git add <resolved-file>
git rm <resolved-file>
```
1. **Undo**
```bash
# discard all local changes in working directory
git reset --hard HEAD
# discard local changes in a specific <file>
git checkout HEAD <file>
# revert a <commit> (by producing a new commit with contrary changes)
git revert <commit>
# reset head pointer to a previous <commit>...and discard all changes since then
git reset --hard <commit>
# ...and preserve all changes as unstaged changes
git reset <commit>
# ...and preserve uncommitted local changes
git reset --keep <commit>
```
1. **Other Suggestions**
  - Commit related changes eg. 2 bug fixes should result in 2 commits
  - Commit often to reduce merge conflicts; incremental changes
  - Do not commit half-done work. If working on a larger feature split it into smaller logical groups. If you need a clean working copy use git's `stash` feature
  - Test code before you commit; test thoroughly. No half measures
  - Version control is not a backup system. Pay attention to committing semantically (see related changes). Don't just cram in files
  - Write good commit messages. Start w/ a summary (50 character max). Separate from the body by including a blank line. Body should always provide the motivation for the change and how it differs from the previous implementation. Use imperative, present tense eg. change, **not** changed or changes.
  - Use branches. Let git flow do most of the work.
  - Agree on a workflow. Let git flow do most of the work, but entertain the idea of researching some popular workflows.
    - long-running branches
    - topic branches
    - merge or rebase
    - git-flow
  - Help & documentation. `git help <command>`
  - Additional resources
    - [git-tower](https://www.git-tower.com/learn)
    - [rogerdudler github](https://rogerdudler.github.io/git-guide/)
    - [git-scm](https://www.git-scm.org)
