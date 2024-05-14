package utils

import (
	"fmt"
	"os"
)

func CreateSymbolicLink(sourcePath string, targetPath string) error {
	err := os.Symlink(sourcePath, targetPath)
	if err != nil {
		return err
	}
	return nil
}
func SymbolicLinkExists(path string) bool {
	_, err := os.Lstat(path)
	return err == nil
}
func EndCli(err *error) {
	endCode := 0
	message := "DOTFILES"
	if *err == nil {
		message = message + "_SUCCESS: Done!"
	} else {
		message = message + "_ERROR: \n" + (*err).Error()
		endCode = 1
	}
	printResult, printError := fmt.Fprintf(os.Stderr, "%s\n", message)
	if printError != nil {
		fmt.Println(printError)
	}
	fmt.Println(printResult)
	os.Exit(endCode)

}
func Ternary(condition bool, a interface{}, b interface{}) interface{} {
	if condition {
		return a
	}
	return b
}
