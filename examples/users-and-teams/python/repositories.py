from __future__ import annotations

from typing import Optional

from pydantic import BaseModel


class User(BaseModel):
    id: str
    name: str
    role: str
    team: str


class Team(BaseModel):
    id: str
    name: str
    lead: str
    members: list[str]


class InMemoryUserRepository:
    def __init__(self, users: list[User]) -> None:
        self._store: dict[str, User] = {u.id: u for u in users}

    def get(self, id: str) -> Optional[User]:
        return self._store.get(id)

    def all(self) -> list[User]:
        return list(self._store.values())


class InMemoryTeamRepository:
    def __init__(self, teams: list[Team]) -> None:
        self._store: dict[str, Team] = {t.id: t for t in teams}

    def get(self, id: str) -> Optional[Team]:
        return self._store.get(id)

    def all(self) -> list[Team]:
        return list(self._store.values())
