package manager

import (
	"dotfiles/types"
	"errors"
	"fmt"
	"github.com/hjson/hjson-go/v4"
	"os/exec"
	"runtime"
)

var osDefaultPackageManagers = ""

func checkCommandExists(command string) bool {
	_, err := exec.LookPath(command)
	return err == nil
}

type PackageManagerContext struct {
	settings *types.Settings
	context  *types.Context
}

func (p *PackageManagerContext) InstallPackage(packageName string, options *types.PackageManagerOptions) error {
	osDistribution := runtime.GOOS
	js, _ := hjson.MarshalWithOptions(&p.settings, hjson.EncoderOptions{
		Comments:        true,
		IndentBy:        "	",
		BaseIndentation: "",
		Eol:             "\n",
		QuoteAlways:     true,
	})
	fmt.Printf("%v", string(js))
	if p.osSectionIsEmpty() {
		return errors.New(fmt.Sprintf("No package managers configuration found in OS section of the configuration file: %s", p.context.DotfilesConfigurationFilePath))
	}
	fmt.Println("Caiu AQui2")
	// check if p.osConfiguration.OsPackageM	anagers contains osDistribution
	_, containsOsDistribution := p.settings.Os.OsPackageManagers[osDistribution]
	if !containsOsDistribution {
		return errors.New(fmt.Sprintf("No package managers configuration found for OS: %s in OS section of the configuration file: %s", osDistribution, p.context.DotfilesConfigurationFilePath))
	}
	fmt.Println("Caiu AQui3")
	//for _, osPackageManager := range distributionsPackageManagers.Commads {
	//	fmt.Println(osPackageManager)
	//}
	return nil
}

func (p *PackageManagerContext) osSectionIsEmpty() bool {
	return len(p.settings.Os.OsPackageManagers) == 0
}

func NewPackageManagerContext(context *types.Context, settings *types.Settings) *PackageManagerContext {
	return &PackageManagerContext{
		settings: settings,
		context:  context,
	}
}

//func determinePackageManager(useBrew bool) string {
//	switch runtime.GOOS {
//
//	case "linux":
//		if useBrew {
//			return "brew"
//		}
//		// List of common package managers on Linux
//		pkgManagers := map[string]string{
//			"apt-get": "Debian, Ubuntu, and derivatives",
//			"dnf":     "Fedora",
//			"yum":     "Older versions of Fedora and CentOS",
//			"zypper":  "openSUSE",
//			"pacman":  "Arch Linux",
//		}
//
//		for cmd, osType := range pkgManagers {
//			if checkCommandExists(cmd) {
//				fmt.Printf("Detected OS type based on package manager: %s\n", osType)
//				return cmd
//			}
//		}
//	case "darwin":
//		if checkCommandExists("brew") {
//			return "brew" // Homebrew for macOS
//		}
//
//	case "windows":
//		if checkCommandExists("choco") {
//			return "choco" // Chocolatey for Windows
//		}
//	}
//	return constants.UnknowOsPackageManager
//}
