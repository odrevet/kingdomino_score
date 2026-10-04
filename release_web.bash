#!/usr/bin/env bash
set -e

flutter build web --release --base-href /kingdomino_score/

cp -r build/web /tmp/kingdomino_web

git switch gh-pages
rm -rf -- *
cp -r /tmp/kingdomino_web/. .

git add -A
git commit -m "update web build"
git push origin gh-pages

git switch master

rm -rf /tmp/kingdomino_web