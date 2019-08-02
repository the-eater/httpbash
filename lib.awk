function redirect(to, status) {
    if (!status) {
        status=307
    }

    print "redirect:"status":"to
    exit
}

function write(body, content_type) {
    if (!content_type) {
        content_type="text/plain"
    }

    print "write:"content_type
    print body
    exit
}

function handler(name) {
    print "handler:"name
    exit
}