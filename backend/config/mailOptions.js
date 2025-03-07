const subjectOTPLogin = "OTP for Login";

/**
 * Creates the OTP email body in both plain text and HTML format.
 */
function createOTPEmailBody(otp) {
  return {
    text: `Your OTP for login is: ${otp}`,
    html: `<p>Your OTP for login is: <strong>${otp}</strong></p>`,
  };
}

export const dbName = "test";
export const otpCollectionName = "otpCollection";

/**
 * Generates mail options for sending OTP.
 */
export function getMailOptions(receiverMail, otp) {
  if (!process.env.SENDER_EMAIL) {
    throw new Error("SENDER_EMAIL is not defined in environment variables.");
  }

  const { text, html } = createOTPEmailBody(otp);

  return {
    from: process.env.SENDER_EMAIL,
    to: receiverMail,
    subject: subjectOTPLogin,
    text,
    html,
  };
}
