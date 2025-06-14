#!/bin/bash

# Run apply_tc_rules.sh in the background
./apply_tc_rules.sh &
tc_pid=$!
echo "apply_tc_rules.sh is running in the background with PID $tc_pid"

# Define cleanup function
cleanup() {
    echo "Killing apply_tc_rules.sh with PID $tc_pid"
    kill "$tc_pid" 2>/dev/null
}

# Register the cleanup function to run on script exit
trap cleanup EXIT

# Main script logic goes here
# (e.g. sleep, or whatever task needs to be done)
# Example:
sleep 10

echo "Main script work done."

# When script exits (normally or via Ctrl+C), cleanup will be triggered
