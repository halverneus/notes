# Note Taker Example

## Introduction
Quick example of a web-based note-taking application that compiles into a
standalone binary with no dependencies.

## Configuration

None

## Deployment

### With Docker

```bash
docker build . -t notes
docker run -it -p 8080:8080 notes
```

The web page will be available at: http://localhost:8080

### Without Docker

Requires the following to be installed:

- Dart 2.1.0 or greater.
- Webdev (using Dart pub: pub global activate webdev 1.0.1 )
- Go (1.11.0 or greater with GO111MODULE set to 'on')
- Protoc
- Protoc Gogoslick (using Go install: go install github.com/gogo/protobuf/protoc-gen-gogoslick )

```bash
REPO_ROOT=`pwd`
cd lib/client; webdev build; cd "$REPO_ROOT"
go generate ./...
go run notes.go
```

To create the fully static binary, replace the last line with:

```bash
CGO_ENABLED=0 go build -a -tags netgo -installsuffix netgo -o /notes
```

The web page will be available at: http://localhost:8080
