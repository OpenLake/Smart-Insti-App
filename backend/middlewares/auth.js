import jwt from "jsonwebtoken";
import * as errorMessages from "../constants/errorMessages.js";
const passwordKey = process.env.PASSWORD_KEY;

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token)
      return res.status(401).json({ msg: errorMessages.noAuthToken });

    const verified = jwt.verify(token, passwordKey);
    if (!verified)
      return res
        .status(401)
        .json({ msg: errorMessages.tokenVerificationFailed });

    req.user = verified.id;
    req.token = token;
    next();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

export default auth;
