from __future__ import annotations

from typing import Callable, Generic, Optional, TypeVar

from pydantic import BaseModel

T = TypeVar("T")


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


class InMemoryRepository(Generic[T]):
    def __init__(self, items: list[T], key: Callable[[T], str]) -> None:
        self._store: dict[str, T] = {key(item): item for item in items}

    def get(self, id: str) -> Optional[T]:
        return self._store.get(id)

    def all(self) -> list[T]:
        return list(self._store.values())
