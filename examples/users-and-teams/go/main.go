package main

import (
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"
)

type User struct {
	ID     string `json:"id"`
	Name   string `json:"name"`
	Role   string `json:"role"`
	TeamID string `json:"team_id"`
}

type Team struct {
	ID        string   `json:"id"`
	Name      string   `json:"name"`
	LeadID    string   `json:"lead_id"`
	MemberIDs []string `json:"member_ids"`
}

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

	var rawUsers []*User
	var rawTeams []*Team
	if err := json.Unmarshal(usersData, &rawUsers); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	if err := json.Unmarshal(teamsData, &rawTeams); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	var userRepo UserRepository = NewInMemoryUserRepository(rawUsers)
	var teamRepo TeamRepository = NewInMemoryTeamRepository(rawTeams)

	fmt.Println("UserRepository:")
	allUsers := userRepo.ListUsers()
	sort.Slice(allUsers, func(i, j int) bool { return allUsers[i].ID < allUsers[j].ID })
	for _, u := range allUsers {
		fmt.Printf("  %s: %q  role=%s  team=%s\n", u.ID, u.Name, u.Role, u.TeamID)
	}

	fmt.Println()
	fmt.Println("TeamRepository:")
	allTeams := teamRepo.ListTeams()
	sort.Slice(allTeams, func(i, j int) bool { return allTeams[i].ID < allTeams[j].ID })
	for _, t := range allTeams {
		fmt.Printf("  %s: %q  lead=%s  members=[%s]\n", t.ID, t.Name, t.LeadID, strings.Join(t.MemberIDs, ", "))
	}
}
