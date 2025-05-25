import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import express from "express";
import authRoutes from "./routes/auth.routes";

admin.initializeApp();
const app = express();
app.use(express.json());

// mount the routes
app.use("/auth", authRoutes);

exports.api = functions.https.onRequest(app);
