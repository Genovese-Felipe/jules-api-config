#!/bin/bash

# A Bash script to interact with the Jules API.
# This script requires `curl` and `jq` to be installed.

# --- Configuration ---
# It's recommended to load the API key from environment variables for security.
API_KEY="${JULES_API_KEY:-your_jules_api_key_here}"
BASE_URL="https://api.jules.ai/v1" # Replace with the actual API endpoint

# --- Function to check for required commands ---
check_deps() {
  for cmd in curl jq; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "Error: Required command '$cmd' is not installed." >&2
      exit 1
    fi
  done
}

# --- Function to create a new Jules session ---
create_jules_session() {
  local task_description="$1"
  local url="${BASE_URL}/sessions"

  echo "Attempting to create a new Jules session..."

  # Create the JSON payload
  local payload
  payload=$(jq -n --arg task "$task_description" '{"task": $task}')

  # Make the API call and extract the session ID
  local response
  response=$(curl -s -X POST "$url" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$payload")

  # Check for errors in the response
  if echo "$response" | jq -e '.session_id' > /dev/null; then
    local session_id
    session_id=$(echo "$response" | jq -r '.session_id')
    echo "Successfully created session: $session_id"
    echo "$session_id" # Return the session ID
  else
    echo "Error creating session. Response:" >&2
    echo "$response" >&2
    return 1
  fi
}

# --- Function to monitor session progress ---
monitor_session_progress() {
  local session_id="$1"
  if [ -z "$session_id" ]; then
    echo "Error: Session ID is required." >&2
    return 1
  fi

  local url="${BASE_URL}/sessions/${session_id}"

  echo "Starting to monitor session: $session_id"

  while true; do
    local response
    response=$(curl -s -X GET "$url" -H "Authorization: Bearer $API_KEY")

    local status
    status=$(echo "$response" | jq -r '.status')
    local progress
    progress=$(echo "$response" | jq -r '.progress // "No progress information available."')

    echo "Session Status: ${status^^} - Progress: $progress"

    if [[ "$status" == "completed" || "$status" == "failed" ]]; then
      echo "Session $session_id finished with status: ${status^^}"
      break
    fi

    # Poll every 10 seconds
    sleep 10
  done
}

# --- Main script execution ---
main() {
  echo "--- Jules API Bash Example ---"

  # Check for dependencies
  check_deps

  # Check for API Key
  if [[ "$API_KEY" == "your_jules_api_key_here" ]]; then
    echo "Warning: API key is not set. Please set the JULES_API_KEY environment variable."
  fi

  local task="Create a Bash script to zip a directory."
  local session_id

  session_id=$(create_jules_session "$task")

  if [ -n "$session_id" ]; then
    # Handle potential SIGINT (Ctrl+C)
    trap 'echo "\nMonitoring stopped by user."; exit 0' SIGINT
    monitor_session_progress "$session_id"
  fi
}

# Run the main function
main
