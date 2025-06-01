import {Response} from "express";
import {upsertUser} from "../services/user.service";

/**
 * Middleware to authenticate Firebase ID token from Authorization header.
 * Adds decoded user info to `req.user` if valid.
 *
 * @param req - Express request object, extended with `user` field.
 * @param res - Express response object.
 * @param next - Express next function to pass control.
 */

export async function googleSignIn(req: any, res: Response) {
  try {
    const {uid, email, name, picture} = req.user;

    const user = await upsertUser(uid, {
      email,
      displayName: name,
      photoURL: picture,
    });

    res.status(200).json({
      success: true,
      user,
    });
  } catch (error) {
    console.error("Error during Google Sign-In:", error);
    res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
}
