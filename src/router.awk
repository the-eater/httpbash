# Variables sent: method, path, host
# Headers are provided as header_[headername]
#
# Functions available:
#   redirect(url, status=307)
#   write(data, content-type="text/plain")
#   handler(name) - runs handler from src/handlers/{name}.sh
#
method == "GET" && path == "/" {
    write("<h1>hello world!</h1>", "text/html")
}

method == "GET" && path == "/x" {
    redirect("/")
}

path == "/mount" {
    handler("mounts")
}

# Always executed :)
{write("Not found")}