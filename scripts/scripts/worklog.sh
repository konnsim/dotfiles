#!/usr/bin/env bash

WORKLOG_FILE=".workog_commits"
SINCE_DATE="${1:-yesterday}"

git log --since="$SINCE_DATE" --no-merges --pretty=format:"%H %s" --reverse \
| { cat; echo; } \
| while read -r hash title; do
  if [ -n "$hash" ] && ! grep -q "^$hash$" "$WORKLOG_FILE" 2>/dev/null; then
    echo "$title"
    echo "$hash" >> "$WORKLOG_FILE"
  fi
done | tee /dev/tty | clip
