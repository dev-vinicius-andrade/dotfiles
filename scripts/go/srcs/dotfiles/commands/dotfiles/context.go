package dotfiles

import (
	"dotfiles/types"
)

func createContext() types.Context {
	return types.Context{
		DotfilesDir: "",
		Cobra: types.CobraContext{
			ConfigurationFilePath: "",
		},
	}
}
