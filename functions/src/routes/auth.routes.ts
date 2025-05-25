import {Router} from "express";
import {authenticate} from "../middlewares/auth.middleware";
import {googleSignIn} from "../controllers/auth.controller";

// eslint-disable-next-line new-cap
const router = Router();

router.post("/google-signin", authenticate, googleSignIn);

export default router;
