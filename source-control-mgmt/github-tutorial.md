# Basic Github Usage Walk-thru


##### Overview
1. Create repository -- main branch
2. Create and switch to a new named branch -- develop branch or feature-name
3. Edit files and commit changes
4. Open a Pull Request
    - requesting someone review and pull in your changes
    - shows differences between branches
    - @mention in pull request message for feedback from specific people or teams
    - wait for maintainer to respond and possibly create milestones
5. As package repository maintainer review changes, respond, and finally merge (or close) the pull request.
6. command line may be used to resolve the pull request
  - connect w/ either HTTPS: `https://github.com/user/git-repository.git`  or SSH: `git@github.com:user/git-repository.git`
  - **Step 1**: From project repository, bring in the changes and test.
```
  git fetch origin
  git checkout -b edited-git-branch-downstream origin/edited-git-branch-downstream
  git merge main
```
  - **Step 2**: Merge the changes and update on GitHub:
```
  git checkout main # or other upstream branch
  git merge --no-ff edited-git-branch-downstream
  git push origin main # or other upstream branch
```
