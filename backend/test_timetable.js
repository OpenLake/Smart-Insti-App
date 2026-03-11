async function testTimetable() {
  const hubUrl = 'https://hub.openlake.in/api/v1/academics/timetable';
  console.log(`🚀 Fetching Timetable from: ${hubUrl}\n`);

  try {
    const response = await fetch(hubUrl);
    const body = await response.json();

    if (response.status === 200) {
      console.log('✅ Timetable Response: SUCCESS');
      if (Array.isArray(body)) {
        console.log('Length:', body.length);
        console.log('First Item:', JSON.stringify(body[0], null, 2));
      } else {
        console.log('Body:', JSON.stringify(body, null, 2));
      }
    } else {
      console.log(`❌ Timetable Response: FAILED (${response.status})`);
    }
  } catch (error) {
    console.log(`🔥 Error: ${error.message}`);
  }
}

testTimetable();
