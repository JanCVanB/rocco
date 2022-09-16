package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func main() {
        http.HandleFunc("/", callRocco)
        port := os.Getenv("PORT")
        if port == "" {
                port = "8080"
                log.Printf("Defaulting to port %s", port)
        }
        log.Printf("Listening on port %s", port)
        if err := http.ListenAndServe(":"+port, nil); err != nil {
                log.Fatal(err)
        }
}

func callRocco(w http.ResponseWriter, r *http.Request) {
        b, err := ioutil.ReadAll(r.Body)
        if err != nil {
                panic(err)
        }
        cmd := exec.CommandContext(
                r.Context(),
                "/app/rocco",
                "post",
                "--payload",
                fmt.Sprintf("'%s'", string(b[:])),
        )
        cmd.Stderr = os.Stderr
        out, err := cmd.Output()
        if err != nil {
                w.WriteHeader(500)
        }
        w.Write(out)
}
