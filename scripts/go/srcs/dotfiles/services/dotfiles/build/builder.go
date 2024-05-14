package build

import (
	"dotfiles/helpers"
	"dotfiles/services/package/manager"
	"dotfiles/types"
	"os/exec"
)

func DotfilesCli(context *types.Context, interactive bool, autoAcceptInstallation bool, cfg *types.Settings) error {
	if isGoInstalled() {
		return runBuild(interactive)
	} else {
		err := installGo(context, autoAcceptInstallation, cfg)
		if err != nil {
			return err
		}
		return runBuild(interactive)
	}
}

func runBuild(interactive bool) error {
	err := build(interactive)
	if err != nil {
		return err
	}
	return nil
}
func isGoInstalled() bool {

	cmd := exec.Command("go", "version")
	if err := cmd.Run(); err == nil {
		return true
	}
	cmd = exec.Command("/usr/local/go/bin/go", "version")
	if err := cmd.Run(); err == nil {
		return true
	}
	return false
}
func build(interactive bool) error {

	return nil
}
func installGo(context *types.Context, autoAcceptInstallation bool, cfg *types.Settings) error {

	s := helpers.NewSpinner().SetTotalSteps(100).Start()
	s.SetMessage("Installing Go...")
	_ = manager.NewPackageManagerContext(context, cfg).InstallPackage("go", &types.PackageManagerOptions{
		AutoAcceptInstallation: &autoAcceptInstallation,
	})

	s.Finish()
	return nil
}
