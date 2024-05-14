package types

import (
	"dotfiles/types/interfaces"

	"github.com/spf13/cobra"
)

type CommandDefinition struct {
	interfaces.CommandDefinition
}
type CobraContext struct {
	ConfigurationFilePath string
}
type Context struct {
	DotfilesDir                   string
	Interactive                   bool
	AutoAcceptPackagesInstall     bool
	DotfilesConfigurationFilename string
	DotfilesConfigurationFilePath string
	UseHomeBrew                   bool
	InstallPrerequisitesPackages  bool
	UpdatePackageManager          bool
	DotfilesCmd                   cobra.Command
	Cobra                         CobraContext
}
type CobraHelpOptions struct {
	Title string
}
type PackageOptionsPreferenceConfiguration struct {
	PackageManager *string `json:"packageManager,omitempty" yaml:"packageManager,omitempty"`
}
type PackageOptionsConfiguration struct {
	Preferences *PackageOptionsPreferenceConfiguration `json:"preferences,omitempty" yaml:"preferences,omitempty"`
}
type PackageConfiguration struct {
	Name    *string `json:"name" yaml:"name"`
	Version *string `json:"version,omitempty" yaml:"version,omitempty"`
	Source  *string `json:"source,omitempty" yaml:"source"`
}
type PackageConfigurationWithOptions struct {
	PackageConfiguration
	Options *PackageOptionsConfiguration `json:"options,omitempty" yaml:"options,omitempty"`
}
type PackageOverrideConfiguration struct {
	PackageManagers map[string]map[string]PackageConfiguration `json:"packageManagers" yaml:"packageManagers"`
}
type PackageConfigurationOverride map[string]PackageOverrideConfiguration

type PackagesPackageInformationConfiguration map[string]PackageConfigurationWithOptions
type PackagesConfiguration map[string]PackagesPackageInformationConfiguration
type OsConfiguration struct {
	OsPackageManagers map[string]map[string]PackageManagerConfiguration `json:"packageManagers" yaml:"packageManagers"`
}
type Settings struct {
	Os       OsConfiguration       `json:"os" yaml:"os"`
	Packages PackagesConfiguration `json:"packages" yaml:"packages"`
}
type PackageManagerCommand struct {
	InteractiveCommandTemplate    string `json:"command" yaml:"command"`
	NonInteractiveCommandTemplate string `json:"nonInteractiveCommand" yaml:"nonInteractiveCommand"`
}
type PackageManagerCommands struct {
	Install PackageManagerCommand  `json:"install" yaml:"install"`
	Remove  PackageManagerCommand  `json:"remove,omitempty" yaml:"remove,omitempty"`
	Update  *PackageManagerCommand `json:"update,omitempty" yaml:"update,omitempty"`
	Upgrade *PackageManagerCommand `json:"upgrade,omitempty" yaml:"upgrade,omitempty"`
}
type PackageManagerConfiguration struct {
	Command  string                 `json:"command" yaml:"command"`
	Commands PackageManagerCommands `json:"commands" yaml:"commands"`
}

type PackageManagerOptions struct {
	AutoAcceptInstallation *bool
	UseBrew                *bool
}
