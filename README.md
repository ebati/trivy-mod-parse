# Test repo for trivy go mod parsing

`go.mod` have both require and replace statements. Dependencies are vendored using `go mod vendor` command.

When i build the app in my computer (where i vendored the dependencies), i get the correct dep path, version and _hash_ values using `go version -m trivy-mod-parse`.

```sh
$ go build .
$ go version -m trivy-mod-parse
trivy-mod-parse: go1.16.4
        path    github.com/ebati/trivy-mod-parse
        mod     github.com/ebati/trivy-mod-parse        (devel)
        dep     github.com/davecgh/go-spew      v1.1.1  h1:vj9j/u1bqnvCEfJOwUhtlOARqs3+rkHYY13jYWTU97c=
```

When i build the app using the provided `Dockerfile` and copy the result to my computer, i only get dep path and version (no hash value) with the same `go version -m trivy-mod-parse`.

```sh
$ docker build -t test .
Sending build context to Docker daemon  2.473MB
Step 1/8 : FROM golang:1.16.4-alpine3.13 AS builder
 ---> 722a834ff95b
Step 2/8 : WORKDIR /app
 ---> Running in 56aad129e086
Removing intermediate container 56aad129e086
 ---> 8eddb7031795
Step 3/8 : ENV CGO_ENABLED=0     GOOS=linux     GOARCH=amd64
 ---> Running in 585b91ec6290
Removing intermediate container 585b91ec6290
 ---> b3a22c1b6881
Step 4/8 : COPY . .
 ---> 0f778ced820c
Step 5/8 : RUN go build .
 ---> Running in 297b022c56d1
Removing intermediate container 297b022c56d1
 ---> 238c64950609
Step 6/8 : FROM alpine:3.13
 ---> e50c909a8df2
Step 7/8 : COPY --from=builder /app/trivy-mod-parse /app/trivy-mod-parse
 ---> ebe88e7479f6
Step 8/8 : ENTRYPOINT ["/app/trivy-mod-parse"]
 ---> Running in a6c7f24452ce
Removing intermediate container a6c7f24452ce
 ---> 628e76fb4d04
Successfully built 628e76fb4d04
Successfully tagged test:latest

$ id=$(docker create test:latest)

$ docker cp $id:/app/trivy-mod-parse .

$ docker rm -v $id

$ go version -m trivy-mod-parse
trivy-mod-parse: go1.16.4
        path    github.com/ebati/trivy-mod-parse
        mod     github.com/ebati/trivy-mod-parse        (devel)
        dep     github.com/davecgh/go-spew      v1.1.1
```
