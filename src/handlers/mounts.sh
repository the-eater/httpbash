# Header sets the header
header "Connection" "close"
header "Content-Type" "text/plain"
# Respond builds the head
respond 200
# Write body
mount
# Close connection
close
