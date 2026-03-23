import json
import os

import team_pb2  # noqa: F401  (confirms stubs compiled correctly)
import user_pb2  # noqa: F401

from repositories import InMemoryRepository, Team, User

with open(os.environ["USERS_DATA"]) as f:
    users_data = json.load(f)

with open(os.environ["TEAMS_DATA"]) as f:
    teams_data = json.load(f)

user_repo: InMemoryRepository[User] = InMemoryRepository([User(**u) for u in users_data], lambda u: u.id)
team_repo: InMemoryRepository[Team] = InMemoryRepository([Team(**t) for t in teams_data], lambda t: t.id)

print("UserRepository:")
for user in user_repo.all():
    print(f"  {user.id}: {user.name!r}  role={user.role}  team={user.team}")

print()
print("TeamRepository:")
for team in team_repo.all():
    print(f"  {team.id}: {team.name!r}  lead={team.lead}  members={team.members}")
