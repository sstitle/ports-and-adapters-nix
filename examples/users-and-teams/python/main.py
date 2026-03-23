import json
import os

import user_pb2  # noqa: F401  (confirms base stubs compiled)
import team_pb2  # noqa: F401
import user_service_pb2  # noqa: F401  (confirms service stubs compiled)
import team_service_pb2  # noqa: F401

from user_repository import InMemoryUserRepository
from team_repository import InMemoryTeamRepository
from user_servicer import UserServicer  # noqa: F401  (confirms gRPC servicer generated)
from team_servicer import TeamServicer  # noqa: F401

with open(os.environ["USERS_DATA"]) as f:
    users_data = json.load(f)

with open(os.environ["TEAMS_DATA"]) as f:
    teams_data = json.load(f)

user_repo = InMemoryUserRepository(users_data)
team_repo = InMemoryTeamRepository(teams_data)

print("UserRepository:")
for user in user_repo.list():
    print(f"  {user.id}: {user.name!r}  role={user.role}  team={user.team_id}")

print()
print("TeamRepository:")
for team in team_repo.list():
    print(f"  {team.id}: {team.name!r}  lead={team.lead_id}  members={list(team.member_ids)}")
