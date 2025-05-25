import * as admin from "firebase-admin";
import {Response, NextFunction} from "express";

/**
 * Middleware to authenticate Firebase ID token from Authorization header.
 * Adds decoded user info to `req.user` if valid.
 *
 * @param req - Express request object, extended with `user` field.
 * @param res - Express response object.
 * @param next - Express next function to pass control.
 */

export async function authenticate(req: any, res: Response, next: NextFunction){
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({error: "Missing or invalid token"});
  }

  const idToken = authHeader.split("Bearer ")[1];
  try {
    const decoded = await admin.auth().verifyIdToken(idToken);
    req.user = decoded;
    return next();
  } catch (err) {
    console.error("Auth error:", err);
    return res.status(401).json({error: "Invalid token"});
  }
}
