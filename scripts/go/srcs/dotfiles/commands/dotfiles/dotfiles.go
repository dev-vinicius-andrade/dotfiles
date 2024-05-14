package dotfiles

import (
	"dotfiles/commands/build"
	"dotfiles/constants"
	"dotfiles/helpers"
	"dotfiles/types"
	"fmt"
	"github.com/spf13/cobra"
	"path/filepath"
)

var context = createContext()

type commandDefinition struct{}

func (c *commandDefinition) CreateCommandDefinition() *cobra.Command {
	command := cobra.Command{
		Use:              "dotfiles",
		Short:            "Dotfiles is a CLI tool to manage your dotfiles.",
		Long:             `The main goal of this tool is to help installing requirements`,
		Aliases:          []string{"df"},
		TraverseChildren: true,
	}
	homeDir, err := helpers.HomeDir()
	if err != nil {
		fmt.Println(err)
	}
	defineFlags(homeDir, &command)
	defineSubCommands(&command)
	setRunCommand(&command)
	return &command
}

func defineSubCommands(cmd *cobra.Command) {
	build.CreateCommand(&context, cmd)

}

func runCommand(cmd *cobra.Command, args []string) {
	if len(args) == 0 {
		helpers.CobraHelper.ShowHelp(cmd, &types.CobraHelpOptions{Title: "Dotfiles command"})
		return
	}
}

func setRunCommand(command *cobra.Command) {
	command.Run = runCommand
}

func defineFlags(homeDir string, command *cobra.Command) {
	defaultDotfilesDir := filepath.Join(homeDir, constants.DefaultDotfilesDirname)
	defaultConfigurationFilePath := filepath.Join(defaultDotfilesDir, constants.DefaultConfigurationFileName)

	command.PersistentFlags().StringVarP(&context.DotfilesDir, "dir", "D", defaultDotfilesDir, "Dotfiles directory")
	command.PersistentFlags().BoolVarP(&context.Interactive, "interactive", "I", false, "Interactive mode")
	command.PersistentFlags().BoolVarP(&context.UseHomeBrew, "use-homebrew", "B", false, "Use Homebrew")
	command.Flags().BoolVarP(&context.AutoAcceptPackagesInstall, "auto-accept", "Y", false, "Auto accept packages install")
	command.Flags().StringVarP(&context.Cobra.ConfigurationFilePath, "config-path", "C", defaultConfigurationFilePath, "Configuration file path")
	command.Flags().StringVarP(&context.DotfilesConfigurationFilename, "config-filename", "F", constants.DefaultConfigurationFileName, "Configuration file name")
	command.Flags().BoolVarP(&context.InstallPrerequisitesPackages, "install-prerequisites", "P", false, "Install prerequisites packages")
	command.Flags().BoolVarP(&context.UpdatePackageManager, "update-package-manager", "U", false, "Skip package management update")

}

func CreateCommand() *cobra.Command {
	c := commandDefinition{}
	return c.CreateCommandDefinition()
}
