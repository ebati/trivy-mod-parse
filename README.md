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
        dep     github.com/go-sql-driver/mysql  v0.0.0-00010101000000-000000000000
        =>      github.com/go-sql-driver/mysql  v1.5.0  h1:ozyZYNQW3x3HtqT1jira07DN2PArx2v7/mN66gGcHOs=
```

When i build the app using the provided `Dockerfile` and copy the result to my computer, i only get dep path and version (no hash value) with the same `go version -m trivy-mod-parse`.

```sh
$ docker build -t test .
Sending build context to Docker daemon  542.7kB
Step 1/8 : FROM golang:1.16.4-alpine3.13 AS builder
 ---> 722a834ff95b
Step 2/8 : WORKDIR /app
 ---> Running in 2c9ae0a7920b
Removing intermediate container 2c9ae0a7920b
 ---> e1d8c7965598
Step 3/8 : ENV CGO_ENABLED=0     GOOS=linux     GOARCH=amd64
 ---> Running in b210edaffba7
Removing intermediate container b210edaffba7
 ---> bf0615a019cc
Step 4/8 : COPY . .
 ---> 548bfbb2285c
Step 5/8 : RUN go build .
 ---> Running in fcb7b6d749b6
Removing intermediate container fcb7b6d749b6
 ---> 13ca8bde9b4b
Step 6/8 : FROM alpine:3.13
 ---> e50c909a8df2
Step 7/8 : COPY --from=builder /app/trivy-mod-parse /app/trivy-mod-parse
 ---> 6b8d7ed462ab
Step 8/8 : ENTRYPOINT ["/app/trivy-mod-parse"]
 ---> Running in c31402e1e4a2
Removing intermediate container c31402e1e4a2
 ---> b3a3d1ca5998
Successfully built b3a3d1ca5998
Successfully tagged test:latest

$ id=$(docker create test:latest)

$ docker cp $id:/app/trivy-mod-parse .

$ docker rm -v $id
06c4829e8beea238883b6495767e12db6e6458d6bc87eb4b0a7d27df1cee370c

$ go version -m trivy-mod-parse
trivy-mod-parse: go1.16.4
        path    github.com/ebati/trivy-mod-parse
        mod     github.com/ebati/trivy-mod-parse        (devel)
        dep     github.com/davecgh/go-spew      v1.1.1
        dep     github.com/go-sql-driver/mysql  v0.0.0-00010101000000-000000000000
        =>      github.com/go-sql-driver/mysql  v1.5.0
```
