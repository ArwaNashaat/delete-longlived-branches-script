#!/bin/bash

git config --global --add safe.directory '*'
git fetch

dateToDeleteAfter=$(date -d "$(date +%Y-%m-%d) -3 month" +%d-%b-%Y)

for branch in $(git branch -r | grep -v HEAD | grep -v develop | grep -v master | grep -v main | sed /\*/d); do
  commitsAheadOfDevelop=$(git rev-list --right-only --count origin/develop...${branch})
  if [ -z "$(git log -1 --since=$dateToDeleteAfter -s ${branch})" ] && [ $commitsAheadOfDevelop -eq 0 ]; then
    echo -e $(git show --format="%cr" ${branch} | head -n 1) \\t$branch
    remote_branch=$(echo ${branch} | sed 's#origin/##')
        git push origin --delete ${remote_branch}
  fi
done
