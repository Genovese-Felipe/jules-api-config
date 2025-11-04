import os
import time
import requests

# --- Configuration ---
# It's recommended to load the API key from environment variables for security.
API_KEY = os.environ.get("JULES_API_KEY", "your_jules_api_key_here")
BASE_URL = "https://api.jules.ai/v1"  # Replace with the actual API endpoint

HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
}

def create_jules_session(task_description):
    """
    Creates a new session with the Jules API.
    """
    url = f"{BASE_URL}/sessions"
    payload = {"task": task_description}

    print("Attempting to create a new Jules session...")
    try:
        response = requests.post(url, json=payload, headers=HEADERS)
        response.raise_for_status()  # Raises an HTTPError for bad responses (4xx or 5xx)

        session_data = response.json()
        print(f"Successfully created session: {session_data.get('session_id')}")
        return session_data
    except requests.exceptions.RequestException as e:
        print(f"Error creating session: {e}")
        return None

def monitor_session_progress(session_id):
    """
    Monitors the progress of a given Jules session until it completes or fails.
    """
    if not session_id:
        return

    url = f"{BASE_URL}/sessions/{session_id}"

    print(f"Starting to monitor session: {session_id}")
    while True:
        try:
            response = requests.get(url, headers=HEADERS)
            response.raise_for_status()

            session_data = response.json()
            status = session_data.get("status")
            progress = session_data.get("progress", "No progress information available.")

            print(f"Session Status: {status.upper()} - Progress: {progress}")

            if status in ["completed", "failed"]:
                print(f"Session {session_id} finished with status: {status.upper()}")
                break

            # Poll every 10 seconds. Adjust as needed.
            time.sleep(10)

        except requests.exceptions.RequestException as e:
            print(f"Error fetching session status: {e}")
            break
        except KeyboardInterrupt:
            print("\nMonitoring stopped by user.")
            break

def main():
    """
    Main function to demonstrate the Jules API interaction.
    """
    print("--- Jules API Python Example ---")

    # Check for API Key
    if API_KEY == "your_jules_api_key_here":
        print("Warning: API key is not set. Please set the JULES_API_KEY environment variable.")
        # You might want to exit here in a real application
        # return

    task = "Write a Python script to sort a list of numbers."
    session = create_jules_session(task)

    if session:
        monitor_session_progress(session.get("session_id"))

if __name__ == "__main__":
    main()
