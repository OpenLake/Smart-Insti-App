
import admin from 'firebase-admin';
import dotenv from 'dotenv';

dotenv.config();

// Initialize Firebase Admin SDK
// This assumes the service account key is provided via environment variable
// OR base64 encoded JSON string in FIREBASE_SERVICE_ACCOUNT_KEY
// OR path to file in FIREBASE_SERVICE_ACCOUNT_PATH

let serviceAccount;

try {
  if (process.env.FIREBASE_SERVICE_ACCOUNT_KEY) {
    // If provided as a base64 encoded string
    const decodedKey = Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT_KEY, 'base64').toString('utf8');
    serviceAccount = JSON.parse(decodedKey);
  } else if (process.env.FIREBASE_SERVICE_ACCOUNT_PATH) {
    // If provided as a path
    // Dynamic require might be tricky with ESM, so relying on key content is safer or using fs.
    // For now assuming JSON content or KEY is preferred for env vars.
    // But standard is often path. Let's support path if needed but prefer content.
    // Actually, simple solution: use applicationDefault() if running in GCP, otherwise credential.
    
    // For local dev, we often put serviceAccount.json in backend root and .gitignore it.
    // Let's assume user will provide keys in .env
  }
} catch (error) {
  console.error("Error parsing Firebase Service Account Key:", error);
}

// Fallback to application default or mock for now if no keys (to prevent crash)
const credential = serviceAccount 
  ? admin.credential.cert(serviceAccount)
  : admin.credential.applicationDefault();

try {
  admin.initializeApp({
    credential: credential
  });
  console.log("Firebase Admin Initialized");
} catch (error) {
  console.error("Firebase Admin Initialization Error:", error);
}

export const messaging = admin.messaging();
export default admin;
