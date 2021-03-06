#!/usr/bin/env bash

set -v            # print commands before execution, but don't expand env vars in output
set -o errexit    # always exit on error
set -o pipefail   # honor exit codes when piping
set -o nounset    # fail on unset variables

git clone "https://codeexpander-bot:$GH_TOKEN@github.com/onceworl/codeexpander-snippets" app
cd app
npm ci

npm run test-all

# bail if nothing changed
if [ "$(git status --porcelain)" = "" ]; then
  echo "no new content found; goodbye!"
  exit
fi

git config user.email xudaolong@gmail.com
git config user.name codeexpander-bot
git add .
git commit -am "update apps" --author "Codeexpander Bot <xudaolong@github.com>"
npm version minor -m "bump minor to %s"
git pull --rebase
git push origin master
git push origin master --tags
npm publish
