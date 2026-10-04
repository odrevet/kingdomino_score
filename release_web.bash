#!/usr/bin/env bash
set -e

flutter build web --release --base-href /kingdomino_score/

git switch gh-pages
rm -rf -- *
cp -r build/web/. .

git add -A
git commit -m "update web build"
git push origin gh-pages

git switch master