#!/bin/bash

# branches to keep
keep_branches=("->" "origin/HEAD" "origin/main" "origin/master" "origin/piloto" "origin/develop" "origin/dev")

date_to_delete_before="2023-01-01"

git remote prune origin
# Store the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Get a list of all remote branches in the repository
remote_branches=$(git branch -r)

# Loop through the list of remote branches and delete each one
for branch in $remote_branches; do
#   # Skip the current branch
if [[  ! " ${keep_branches[*]} " == *" $branch "* ]]; then
  data_of_last_commit=$(git show --pretty=format:"%ad" --date=format:"%Y-%m-%d" $branch | head -n 1) 
  timestamp1=$(date -j -f "%Y-%m-%d" "$data_of_last_commit" +"%s")
  timestamp2=$(date -j -f "%Y-%m-%d" "$date_to_delete_before" +"%s")
  if [ $timestamp1 -gt $timestamp2 ]; then
    echo -e "-> KEEP: Data: $data_of_last_commit: \tbranch: $branch"
  else
    echo -e "DELETE: Data: $data_of_last_commit: \tbranch: $branch"
    # Delete the remote branch
    git push origin --delete ${branch#origin/}
  fi
  continue
fi
    echo -e "-> SKIP: Data: $data_of_last_commit: \tbranch: $branch"
done

