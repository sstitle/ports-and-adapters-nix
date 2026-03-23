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

// Repository is the port — the interface all adapters must satisfy.
type Repository[T any] interface {
	Get(id string) (T, bool)
	All() []T
}

// InMemoryRepository is the adapter — a generic in-memory implementation.
type InMemoryRepository[T any] struct {
	store map[string]T
}

func NewInMemoryRepository[T any](items []T, key func(T) string) *InMemoryRepository[T] {
	store := make(map[string]T, len(items))
	for _, item := range items {
		store[key(item)] = item
	}
	return &InMemoryRepository[T]{store: store}
}

func (r *InMemoryRepository[T]) Get(id string) (T, bool) {
	v, ok := r.store[id]
	return v, ok
}

func (r *InMemoryRepository[T]) All() []T {
	out := make([]T, 0, len(r.store))
	for _, v := range r.store {
		out = append(out, v)
	}
	return out
}
