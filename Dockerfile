################################################################################
## DART BUILDER
################################################################################
FROM google/dart:2.1.0 AS dart_builder

# Get dependencies before getting code (optimized for Docker).
RUN pub global activate webdev 1.0.1
WORKDIR /app
COPY lib/client/pubspec.* ./
RUN pub get
ADD lib/client/ ./

# Link dependencies, delete build directory from host and grab minimal artifacts.
RUN pub get --offline && \
    pub global run webdev build && \
    bash -c 'mkdir -p /out/{css,script}' && \
    mv build/css/index.css /out/css/ && \
    mv build/script/main.dart.js /out/script/ && \
    mv build/index.html /out/

################################################################################
## GO BUILDER
################################################################################
FROM golang:1.11.3 as go_builder

ENV GO111MODULE on
ENV BUILD_DIR /go/src/github.com/halverneus/notes

# Install Protoc to generate protobuf content.
RUN apt update && apt install -y unzip && \
    wget -O protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip" && \
    unzip protoc.zip 'include/*' -d /usr/local/ && \
    unzip protoc.zip bin/protoc -d /usr/ && \
    chmod +x /usr/bin/protoc && \
    rm protoc.zip && \
    apt remove -y unzip && \
    rm -rf /var/lib/apt/lists/*

# Get dependencies before getting code (optimized for Docker).
WORKDIR ${BUILD_DIR}
COPY go.* ./
RUN go mod download && go install github.com/gogo/protobuf/protoc-gen-gogoslick
COPY . .

# Install the web client.
COPY --from=dart_builder /out/ $BUILD_DIR/lib/client/build/

# Run all unitests with race condition detector and report code coverage. Build.
RUN go generate ./... && \
    go test -race -cover ./... && \
    CGO_ENABLED=0 go build -a -tags netgo -installsuffix netgo -o /notes

################################################################################
## DEPLOYMENT CONTAINER
################################################################################
FROM scratch
EXPOSE 8080
COPY --from=go_builder /notes /
ENTRYPOINT [ "/notes" ]
CMD []
