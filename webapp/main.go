package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", root)
	http.HandleFunc("/homersimpson/", render_homer)
	http.HandleFunc("/homer.png", display_homer)
	http.HandleFunc("/covilha/", covilha)
	http.ListenAndServe(":8080", nil)
}

func root(w http.ResponseWriter, req *http.Request) {
	fmt.Fprint(w, "Nothing here, try going to: \n/homersimpson\n/covilha")
}

func render_homer(w http.ResponseWriter, req *http.Request) {
	tpl, err := template.ParseFiles("homer.gohtml")
	if err != nil {
		log.Fatalln(err)
	}
	tpl.ExecuteTemplate(w, "homer.gohtml", nil)
}

func display_homer(w http.ResponseWriter, req *http.Request) {
	http.ServeFile(w, req, "homer.png")
}

func covilha(w http.ResponseWriter, req *http.Request) {
	// time in current location + output format
	t := time.Now()
	tf := t.Format(time.Kitchen)
	fmt.Fprint(w, "Time at your location is now: ", tf, "\n")

	// set target timezone
	loc, _ := time.LoadLocation("Europe/Lisbon")
	cloc := "Covilha, Portugal"

	// set target timezone time + output format
	now := time.Now().In(loc)
	tfc := now.Format(time.Kitchen)
	fmt.Fprintf(w, "Time in %s is now: %s", cloc, tfc)
}
