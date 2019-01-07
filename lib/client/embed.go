package main

//go:generate go run embed.go

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/shurcooL/vfsgen"
)

var (
	filesDir = "build"
	files    = []string{
		"index.html",
		"css/index.css",
		"script/main.dart.js",
	}
	genOpts = vfsgen.Options{
		Filename:     "serve/serve.go",
		PackageName:  "serve",
		VariableName: "File",
	}
)

func main() {
	// Create a temporary directory.
	tmpDir, err := ioutil.TempDir(os.TempDir(), "sort-build")
	if nil != err {
		log.Fatalf("Failed to create a temporary directory with: %v", err)
	}

	// Clean-up temporary directory on exit.
	defer os.RemoveAll(tmpDir)

	// Copy white-listed artifacts to the temporary directory.
	for _, f := range files {
		orig := filepath.Join(filesDir, f)
		next := filepath.Join(tmpDir, f)

		// Ensure all directories exist in the temporary directory.
		dirs := filepath.Dir(next)
		if err = os.MkdirAll(dirs, 0775); nil != err {
			log.Fatalf(
				"While creating directories %s while copying %s to %s got: %v",
				dirs, orig, next, err,
			)
		}

		// Copy the file.
		if err = os.Link(orig, next); nil != err {
			log.Fatalf(
				"While copying file %s to %s got: %v",
				orig, next, err,
			)
		}
	}

	// Generate package directory.
	if err = os.MkdirAll(filepath.Dir(genOpts.Filename), 0775); nil != err {
		log.Fatalf(
			"While generating package directory %s got: %v",
			genOpts.Filename, err,
		)
	}

	// Generate statically embedded resources.
	var fs http.FileSystem = http.Dir(tmpDir)
	if err = vfsgen.Generate(fs, genOpts); nil != err {
		log.Fatalf("While generating content got: %v", err)
	}
}
