/**
 * Hub Integration Test
 * This script calls the ACTUAL Hub endpoint to trigger the bundle aggregation.
 */
async function testHubBundle() {
  const email = 'amayd@iitbhilai.ac.in';
  const hubUrl = 'https://hub.openlake.in/api/v1/user/aggregate';
  const internalSecret = 'ol_hub_EoqOB3DI7pTCCyayV8ezDk1WgbVgQZCC';

  console.log(`🚀 Requesting Actual Hub Bundle for: ${email}\n`);

  try {
    const response = await fetch(`${hubUrl}?email=${email}`, {
      headers: { 
        'X-Hub-Secret': internalSecret,
        'Accept': 'application/json'
      }
    });

    const body = await response.json();

    if (response.status === 200) {
      console.log('✅ Hub Response: SUCCESS');
      console.log(JSON.stringify(body, null, 2));
    } else {
      console.log(`❌ Hub Response: FAILED (${response.status})`);
      console.log(JSON.stringify(body, null, 2));
    }
  } catch (error) {
    console.log(`🔥 Network Error: ${error.message}`);
    console.log('Ensure the Hub is running on port 3000!');
  }
}

testHubBundle();
