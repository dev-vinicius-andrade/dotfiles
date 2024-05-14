package main

import (
	"dotfiles/commands/dotfiles"
	"fmt"
	"os"
)

func main() {
	command := dotfiles.CreateCommand()
	if err := command.Execute(); err != nil {
		_, _ = fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
