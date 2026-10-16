curl -fsSL https://api.github.com/repos/Dilly3/apply-track \
  | python3 -c '
import json
import sys

repo = json.load(sys.stdin)
print("repository_id:", repo["id"])
print("repository_owner_id:", repo["owner"]["id"])
print("default_branch:", repo["default_branch"])
'