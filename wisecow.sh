#!/usr/bin/env bash

SRVPORT=4499

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 || {
        echo "Install prerequisites: cowsay fortune"
        exit 1
    }
}

handleRequest() {
    while read -r line; do
        [[ "$line" == $'\r' || -z "$line" ]] && break
    done

    mod=$(fortune)
    cow=$(cowsay "$mod")

    cat <<EOF
HTTP/1.1 200 OK
Content-Type: text/html

<pre>
$cow
</pre>
EOF
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    trap "exit" INT TERM
    trap "kill 0" EXIT

    while true; do
        (handleRequest) | nc -lN $SRVPORT
    done
}

main
