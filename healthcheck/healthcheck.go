//source https://pete-woods.com/2019/02/production-grade-spring-boot-docker-images/
package main

import (
	"net/http"
	"os"
)

func main() {
	_, err := http.Get("http://127.0.0.1:8080/health")
	if err != nil {
		os.Exit(1)
	}
}