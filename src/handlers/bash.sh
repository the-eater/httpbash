header "Content-Type" "text/plain"
respond 200
socatexec:"bash --rcfile src/handlers/rc.sh -i",pty,ctty stdio 2>&1
close
