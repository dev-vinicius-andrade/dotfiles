package build

import (
	"dotfiles/helpers"
	"dotfiles/services/dotfiles/build"
	"dotfiles/services/dotfiles/configuration"
	"dotfiles/types"
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

type commandDefinition struct{}

func runCommand(context *types.Context, cmd *cobra.Command, args []string) {
	//if len(args) == 0 {
	//	helpers.CobraHelper.ShowHelp(cmd, &types.CobraHelpOptions{Title: "Dotfiles Build command"})
	//	return
	//}
	cfg, err := configuration.ReadConfiguration(context.Cobra.ConfigurationFilePath)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	_ = build.DotfilesCli(context, context.Interactive, context.AutoAcceptPackagesInstall, cfg)
}
func (c *commandDefinition) CreateCommandDefinition(context *types.Context, parentCommand *cobra.Command) *cobra.Command {
	command := cobra.Command{
		Use:   "build",
		Short: "Build is a CLI tool to manage your dotfiles.",
		Long:  `Helps building the dotfiles tool case you want to make changes to the source code.`,
	}
	_, err := helpers.HomeDir()
	if err != nil {
		fmt.Println(err)
	}
	command.Run = func(cmd *cobra.Command, args []string) {
		runCommand(context, cmd, args)
	}

	helpers.CobraHelper.AddCommandToParent(&command, parentCommand)
	return &context.DotfilesCmd
}

func CreateCommand(context *types.Context, parentCommand *cobra.Command) *cobra.Command {
	c := commandDefinition{}
	return c.CreateCommandDefinition(context, parentCommand)
}
