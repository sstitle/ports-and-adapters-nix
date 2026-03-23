package main

import (
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"
)

func main() {
	usersData, err := os.ReadFile(os.Getenv("USERS_DATA"))
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	teamsData, err := os.ReadFile(os.Getenv("TEAMS_DATA"))
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	var users []User
	var teams []Team
	if err := json.Unmarshal(usersData, &users); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	if err := json.Unmarshal(teamsData, &teams); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	var userRepo Repository[User] = NewInMemoryRepository(users, func(u User) string { return u.ID })
	var teamRepo Repository[Team] = NewInMemoryRepository(teams, func(t Team) string { return t.ID })

	fmt.Println("UserRepository:")
	allUsers := userRepo.All()
	sort.Slice(allUsers, func(i, j int) bool { return allUsers[i].ID < allUsers[j].ID })
	for _, u := range allUsers {
		fmt.Printf("  %s: %q  role=%s  team=%s\n", u.ID, u.Name, u.Role, u.Team)
	}

	fmt.Println()
	fmt.Println("TeamRepository:")
	allTeams := teamRepo.All()
	sort.Slice(allTeams, func(i, j int) bool { return allTeams[i].ID < allTeams[j].ID })
	for _, t := range allTeams {
		fmt.Printf("  %s: %q  lead=%s  members=[%s]\n", t.ID, t.Name, t.Lead, strings.Join(t.Members, ", "))
	}
}
