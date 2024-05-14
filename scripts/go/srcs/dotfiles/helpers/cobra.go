package helpers

import (
	"dotfiles/types"
	"fmt"
	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

type cobraHelper struct{}

func (c *cobraHelper) AddCommandToParent(command *cobra.Command, parentCommand *cobra.Command) {
	if parentCommand == nil {
		return
	} else {
		parentCommand.AddCommand(command)
	}
}
func (c *cobraHelper) ShowHelp(cmd *cobra.Command, options *types.CobraHelpOptions) {
	if options != nil {
		title := color.New(color.FgCyan, color.Bold)
		_, _ = title.Println(options.Title)
		fmt.Println()
		color.Unset()
	}
	err := cmd.Help()
	if err != nil {
		color.Red("Error: %s", err)
	}
}

var CobraHelper = cobraHelper{}
