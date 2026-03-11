import express from "express";

const authCallbackResource = express.Router();

authCallbackResource.get("/callback", (req, res) => {
  const { code } = req.query;

  if (code) {
    console.log("Supabase Auth Code Received:", code);
    // In a real flow, we'd exchange the code for a session here if needed,
    // but usually the frontend handles the hash fragment after redirect.
    // For Magic Links, the code is in the query.
    
    res.send(`
      <html>
        <head>
          <title>Authentication Successful</title>
          <style>
            body { font-family: sans-serif; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; background: #f4f7f9; }
            .card { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
            h1 { color: #3ecf8e; }
            p { color: #666; }
          </style>
        </head>
        <body>
          <div class="card">
            <h1>Success!</h1>
            <p>You have been authenticated.</p>
            <p>You can now close this window and return to the Smart Insti App.</p>
          </div>
        </body>
      </html>
    `);
  } else {
    res.status(400).send("Authentication code missing.");
  }
});

export default authCallbackResource;
