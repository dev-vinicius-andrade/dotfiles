package configuration

import (
	"dotfiles/helpers"
	"dotfiles/types"
	"errors"
	"fmt"
	"github.com/hjson/hjson-go/v4"
	"os"
)

func ReadConfiguration(path string) (*types.Settings, error) {
	if !helpers.FileExists(path) {
		errorMessage := fmt.Sprintf("Configuration file not found: %s", path)
		fmt.Println(errorMessage)
		return nil, errors.New(errorMessage)
	}
	bytes, readFileErr := readFile(path)
	if readFileErr != nil {
		return nil, readFileErr
	}
	settings, deserializeError := deserialize(bytes)
	if deserializeError != nil {
		return nil, deserializeError
	}

	return settings, nil
}

func readFile(path string) ([]byte, error) {
	bytes, readFileErr := os.ReadFile(path)
	if readFileErr != nil {
		errorMessage := fmt.Sprintf("Error reading configuration file: %s", readFileErr)
		fmt.Println(errorMessage)
		return nil, errors.New(errorMessage)
	}
	return bytes, nil
}

func deserialize(bytes []byte) (*types.Settings, error) {
	var settings types.Settings
	err := hjson.UnmarshalWithOptions(bytes, &settings, hjson.DecoderOptions{})
	if err != nil {
		errorMessage := fmt.Sprintf("Error unmarshalling configuration file: %s", err)
		fmt.Println(errorMessage)
		return nil, errors.New(errorMessage)
	}
	return &settings, nil
}
