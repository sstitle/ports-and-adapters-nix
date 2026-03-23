package main

type User struct {
	ID   string   `json:"id"`
	Name string   `json:"name"`
	Role string   `json:"role"`
	Team string   `json:"team"`
}

type Team struct {
	ID      string   `json:"id"`
	Name    string   `json:"name"`
	Lead    string   `json:"lead"`
	Members []string `json:"members"`
}

type InMemoryUserRepository struct {
	store map[string]User
}

func NewInMemoryUserRepository(users []User) *InMemoryUserRepository {
	store := make(map[string]User, len(users))
	for _, u := range users {
		store[u.ID] = u
	}
	return &InMemoryUserRepository{store: store}
}

func (r *InMemoryUserRepository) Get(id string) (User, bool) {
	u, ok := r.store[id]
	return u, ok
}

func (r *InMemoryUserRepository) All() []User {
	users := make([]User, 0, len(r.store))
	for _, u := range r.store {
		users = append(users, u)
	}
	return users
}

type InMemoryTeamRepository struct {
	store map[string]Team
}

func NewInMemoryTeamRepository(teams []Team) *InMemoryTeamRepository {
	store := make(map[string]Team, len(teams))
	for _, t := range teams {
		store[t.ID] = t
	}
	return &InMemoryTeamRepository{store: store}
}

func (r *InMemoryTeamRepository) Get(id string) (Team, bool) {
	t, ok := r.store[id]
	return t, ok
}

func (r *InMemoryTeamRepository) All() []Team {
	teams := make([]Team, 0, len(r.store))
	for _, t := range r.store {
		teams = append(teams, t)
	}
	return teams
}
