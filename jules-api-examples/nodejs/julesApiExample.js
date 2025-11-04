const axios = require('axios');

// --- Configuration ---
// It's recommended to load the API key from environment variables for security.
const API_KEY = process.env.JULES_API_KEY || 'your_jules_api_key_here';
const BASE_URL = 'https://api.jules.ai/v1'; // Replace with the actual API endpoint

const apiClient = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Authorization': `Bearer ${API_KEY}`,
    'Content-Type': 'application/json',
  },
});

/**
 * Creates a new session with the Jules API.
 * @param {string} taskDescription - The description of the task for Jules.
 * @returns {Promise<object|null>} The session data or null if an error occurs.
 */
async function createJulesSession(taskDescription) {
  console.log('Attempting to create a new Jules session...');
  try {
    const response = await apiClient.post('/sessions', { task: taskDescription });
    console.log(`Successfully created session: ${response.data.session_id}`);
    return response.data;
  } catch (error) {
    console.error(`Error creating session: ${error.message}`);
    return null;
  }
}

/**
 * Monitors the progress of a given Jules session until it completes or fails.
 * @param {string} sessionId - The ID of the session to monitor.
 */
async function monitorSessionProgress(sessionId) {
  if (!sessionId) return;

  console.log(`Starting to monitor session: ${sessionId}`);
  const pollInterval = 10000; // Poll every 10 seconds

  const intervalId = setInterval(async () => {
    try {
      const response = await apiClient.get(`/sessions/${sessionId}`);
      const { status, progress } = response.data;

      console.log(`Session Status: ${status.toUpperCase()} - Progress: ${progress || 'No progress information available.'}`);

      if (status === 'completed' || status === 'failed') {
        console.log(`Session ${sessionId} finished with status: ${status.toUpperCase()}`);
        clearInterval(intervalId);
      }
    } catch (error) {
      console.error(`Error fetching session status: ${error.message}`);
      clearInterval(intervalId);
    }
  }, pollInterval);

  // Handle Ctrl+C to stop monitoring
  process.on('SIGINT', () => {
    console.log('\nMonitoring stopped by user.');
    clearInterval(intervalId);
    process.exit(0);
  });
}

/**
 * Main function to demonstrate the Jules API interaction.
 */
async function main() {
  console.log('--- Jules API Node.js Example ---');

  // Check for API Key
  if (API_KEY === 'your_jules_api_key_here') {
    console.warn('Warning: API key is not set. Please set the JULES_API_KEY environment variable.');
    // You might want to exit here in a real application
    // return;
  }

  const task = 'Create a Node.js script to read a file from the filesystem.';
  const session = await createJulesSession(task);

  if (session) {
    monitorSessionProgress(session.session_id);
  }
}

main();
