export const senderEmail = 'college@gmail.com';
export const subjectOTPLogin = 'OTP for Login';

export function createOTPEmailBody(otp) {
  return `Your OTP for login is: ${otp}`
}
