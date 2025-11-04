# Jules API Interaction Examples

This repository contains example scripts in Python, Node.js, and Bash for interacting with the hypothetical Jules API. Each script demonstrates the core functionalities of:

1.  **Authentication**: Securely connecting to the API using an API key.
2.  **Session Creation**: Starting a new task or session.
3.  **Progress Monitoring**: Polling for status updates until the task is complete.

## Prerequisites

Before running any of the examples, you need to set your Jules API key as an environment variable. This is a security best practice to avoid hardcoding credentials in your code.

**On macOS and Linux:**
```bash
export JULES_API_KEY="your_actual_api_key_here"
```

**On Windows (Command Prompt):**
```cmd
set JULES_API_KEY="your_actual_api_key_here"
```

**On Windows (PowerShell):**
```powershell
$env:JULES_API_KEY="your_actual_api_key_here"
```

Replace `"your_actual_api_key_here"` with the API key you received from Jules.

## Language-Specific Instructions

Below are the instructions for running each example script.

### 🐍 Python

The Python script uses the `requests` library to communicate with the API.

**1. Navigate to the directory:**
```bash
cd python
```

**2. Install dependencies:**
If you don't have the `requests` library installed, you can install it using pip:
```bash
pip install requests
```
It's recommended to do this within a virtual environment.

**3. Run the script:**
```bash
python jules_api_example.py
```

### 🟩 Node.js

The Node.js script uses the `axios` library for making HTTP requests.

**1. Navigate to the directory:**
```bash
cd nodejs
```

**2. Install dependencies:**
The required dependencies are listed in `package.json`. Install them using npm:
```bash
npm install
```

**3. Run the script:**
```bash
npm start
```
or
```bash
node julesApiExample.js
```

### 🐧 Bash

The Bash script relies on `curl` for making web requests and `jq` for parsing JSON from the command line.

**1. Navigate to the directory:**
```bash
cd bash
```

**2. Install dependencies:**

*   **curl**: Usually pre-installed on most Unix-like systems.
*   **jq**: You may need to install this.
    *   **On Debian/Ubuntu:** `sudo apt-get install jq`
    *   **On macOS (using Homebrew):** `brew install jq`
    *   **On CentOS/RHEL:** `sudo yum install jq`

**3. Make the script executable:**
You only need to do this once:
```bash
chmod +x jules_api_example.sh
```

**4. Run the script:**
```bash
./jules_api_example.sh
```
