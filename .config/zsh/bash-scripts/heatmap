#!/bin/bash
git_remote=$1
days_backwards=$2
repository_name="sub-repository"

echo '[1/3] Initializing repository ...'
bash initialize-repository.sh $repository_name 1>/dev/null
if [ $? -ne 0 ]; then
    echo '    ⨯ Initializing repository failed!'
    exit 1
else
    echo '    ✓ Repository successfully initialized!'
fi

echo '[2/3] Creating commits (this can take a few seconds) ...'
bash create-commits.sh $repository_name $days_backwards 1>/dev/null
if [ $? -ne 0 ]; then
    echo '    ⨯ Creating commits failed!'
    exit 1
else
    echo '    ✓ Commits successfully created!'
fi

echo '[3/3] Pushing repository to remote ...'
bash push-to-github.sh $repository_name $git_remote 1>/dev/null
if [ $? -ne 0 ]; then
    echo '    ⨯ Pushing repository to remote failed!'
    exit 1
else
    echo '    ✓ Repository successfully pushed to remote!'
fi
