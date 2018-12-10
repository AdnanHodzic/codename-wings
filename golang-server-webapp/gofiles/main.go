package main

import (
	"html/template"
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var tpl *template.Template

func init() {
	tpl = template.Must(template.New("").Funcs(fm).ParseGlob("templates/*"))
}

func amsTime(t time.Time) string {
	return t.Format(time.Kitchen)
}

func covTime(t time.Time) string {
	loc, _ := time.LoadLocation("Europe/Lisbon")
	now := time.Now().In(loc)
	return now.Format(time.Kitchen)
}

var fm = template.FuncMap{
	"amsTime": amsTime,
	"covTime": covTime,
}

func main() {
	http.Handle("/metrics", promhttp.Handler())

	http.HandleFunc("/", root)
	http.HandleFunc("/homersimpson/", renderHomer)
	http.HandleFunc("/homer.png", displayHomer)
	http.HandleFunc("/covilha/", covilhaTime)
	http.ListenAndServe(":8080", nil)
}

func root(w http.ResponseWriter, req *http.Request) {
	tpl.ExecuteTemplate(w, "index.gohtml", nil)
}

func renderHomer(w http.ResponseWriter, req *http.Request) {
	tpl.ExecuteTemplate(w, "homer.gohtml", nil)
}

func displayHomer(w http.ResponseWriter, req *http.Request) {
	http.ServeFile(w, req, "homer.png")
}

func covilhaTime(w http.ResponseWriter, req *http.Request) {
	tpl.ExecuteTemplate(w, "covilha_time.gohtml", time.Now())
}
