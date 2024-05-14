package helpers

import (
	"os"
	"os/exec"
	"strings"
)

func HomeDir() (string, error) {
	if IsWSL() {

		if home, found := os.LookupEnv("HOME"); found {
			return home, nil
		}

		home, err := exec.Command("bash", "-c", "echo $HOME").Output()

		if err == nil {
			return string(home), nil
		}
		return "", err
	}
	return os.UserHomeDir()
}

func IsWSL() bool {
	releaseInfo, _ := os.ReadFile("/proc/sys/kernel/osrelease")
	return strings.Contains(string(releaseInfo), "microsoft")
}
