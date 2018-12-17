package main

// import all necessary libraries
import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"html/template"
	"net/http"
	"time"
)

// set prometheus.NewCounter for /
var (
	httpRequests = prometheus.NewCounter(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total number of requests",
		})
)

// set prometheus.NewCounter for homersimpson/
var (
	httpRequestsHomerSimpson = prometheus.NewCounter(
		prometheus.CounterOpts{
			Name: "http_requests_total_homersimpson",
			Help: "Total number of requests to homersimpson/",
		})
)

// set prometheus.NewCounter for covilha/
var (
	httpRequestsCovilha = prometheus.NewCounter(
		prometheus.CounterOpts{
			Name: "http_requests_total_covilha",
			Help: "Total number of requests to covilha/",
		})
)

// package level scope definition
var tpl *template.Template

// execute before main func is called
func init() {
	// parse all files under templates/ dir and take value of FuncMap
	tpl = template.Must(template.New("").Funcs(fm).ParseGlob("templates/*"))
	// set MustRegister for all Prometheus http_requests_total.*
	prometheus.MustRegister(httpRequests)
	prometheus.MustRegister(httpRequestsHomerSimpson)
	prometheus.MustRegister(httpRequestsCovilha)
}

// return current time on host in i.e: 3:04PM format
func amsTime(t time.Time) string {
	return t.Format(time.Kitchen)
}

// return time for Lisbon in i.e: 3:04PM format
func covTime(t time.Time) string {
	loc, _ := time.LoadLocation("Europe/Lisbon")
	now := time.Now().In(loc)
	return now.Format(time.Kitchen)
}

// create FuncMap to register functions
// key is a string, value a function
var fm = template.FuncMap{
	"amsTime": amsTime,
	"covTime": covTime,
}

func main() {
	// expose the default metrics
	http.Handle("/metrics", promhttp.Handler())

	// functions and pointers back to request
	http.HandleFunc("/", root)
	http.HandleFunc("/homersimpson/", renderHomer)
	http.HandleFunc("/homer.png", displayHomer)
	http.HandleFunc("/covilha/", covilhaTime)
	http.ListenAndServe(":8080", nil)
}

// call httpRequests and execute index.gohtml template
func root(w http.ResponseWriter, req *http.Request) {
	httpRequests.Inc()
	tpl.ExecuteTemplate(w, "index.gohtml", nil)
}

// call httpRequests and execute homer.gohtml template
func renderHomer(w http.ResponseWriter, req *http.Request) {
	httpRequestsHomerSimpson.Inc()
	tpl.ExecuteTemplate(w, "homer.gohtml", nil)
}

// server homer.png file
func displayHomer(w http.ResponseWriter, req *http.Request) {
	http.ServeFile(w, req, "homer.png")
}

// call httpRequests and execute covilha_time.gohtml template
func covilhaTime(w http.ResponseWriter, req *http.Request) {
	httpRequestsCovilha.Inc()
	tpl.ExecuteTemplate(w, "covilha_time.gohtml", time.Now())
}
