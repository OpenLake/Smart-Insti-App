export const senderEmail = 'arin.nigam@gmail.com';
export const subjectOTPLogin = 'OTP for Login';

export function createOTPEmailBody(otp) {
  return `Your OTP for login is: ${otp}`
}

export const dbName = 'test';
export const collectionName = 'otpCollection';
