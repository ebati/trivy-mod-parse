package main

import (
	"fmt"
	"runtime/debug"

	"github.com/davecgh/go-spew/spew"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	spew.Dump(debug.ReadBuildInfo())

	fmt.Println("test app for trivy go parse")
}
