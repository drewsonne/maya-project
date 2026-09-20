#!/usr/bin/env bash
# Move a hub issue or any satellite PR to a status column on the
# "Maya Dates" project board (ADR 0018/0019).
# Usage: board-status.sh <number> <Backlog|Ready|"In progress"|"In review"|Done> [owner/repo]
# Third argument defaults to drewsonne/maya-project; pass e.g.
# drewsonne/maya-date-fixtures to place a satellite PR. Issues and PRs
# both work. Resolves all IDs at runtime; adds the item if absent.
set -euo pipefail

OWNER=drewsonne
PROJECT=2
ISSUE="${1:?usage: board-status.sh <number> <status> [owner/repo]}"
STATUS="${2:?usage: board-status.sh <number> <status> [owner/repo]}"
FULLREPO="${3:-drewsonne/maya-project}"
REPO="${FULLREPO#*/}"

URL="https://github.com/$FULLREPO/issues/$ISSUE"
if gh api "repos/$FULLREPO/issues/$ISSUE" --jq '.pull_request.url' 2>/dev/null | grep -q .; then
  URL="https://github.com/$FULLREPO/pull/$ISSUE"
fi

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
  --jq ".items[] | select(.content.repository==\"$FULLREPO\" and .content.number==$ISSUE) | .id")
if [ -z "$ITEM_ID" ]; then
  ITEM_ID=$(gh project item-add "$PROJECT" --owner "$OWNER" --url "$URL" --format json --jq .id)
fi

gh project item-edit --project-id "$PROJECT_ID" --id "$ITEM_ID" \
  --field-id "$FIELD_ID" --single-select-option-id "$OPTION_ID" >/dev/null
echo "#$ISSUE -> $STATUS"
