#!/usr/bin/env bash
# Move a hub issue to a status column on the "Maya Dates" project board.
# Usage: board-status.sh <issue-number> <Backlog|Ready|"In progress"|"In review"|Done>
# Resolves all IDs at runtime — nothing board-specific is hardcoded except
# the owner and project number. Adds the issue to the board if absent.
set -euo pipefail

OWNER=drewsonne
PROJECT=1
REPO=maya-project
ISSUE="${1:?usage: board-status.sh <issue-number> <status>}"
STATUS="${2:?usage: board-status.sh <issue-number> <status>}"

PROJECT_ID=$(gh project view "$PROJECT" --owner "$OWNER" --format json --jq .id)
FIELD_ID=$(gh project field-list "$PROJECT" --owner "$OWNER" --format json \
  --jq '.fields[] | select(.name=="Status") | .id')
OPTION_ID=$(gh project field-list "$PROJECT" --owner "$OWNER" --format json \
  --jq ".fields[] | select(.name==\"Status\") | .options[] | select(.name==\"$STATUS\") | .id")
if [ -z "$OPTION_ID" ]; then
  echo "unknown status: $STATUS" >&2
  exit 1
fi

ITEM_ID=$(gh project item-list "$PROJECT" --owner "$OWNER" --limit 500 --format json \
  --jq ".items[] | select(.content.repository==\"$OWNER/$REPO\" and .content.number==$ISSUE) | .id")
if [ -z "$ITEM_ID" ]; then
  ITEM_ID=$(gh project item-add "$PROJECT" --owner "$OWNER" \
    --url "https://github.com/$OWNER/$REPO/issues/$ISSUE" --format json --jq .id)
fi

gh project item-edit --project-id "$PROJECT_ID" --id "$ITEM_ID" \
  --field-id "$FIELD_ID" --single-select-option-id "$OPTION_ID" >/dev/null
echo "#$ISSUE -> $STATUS"
