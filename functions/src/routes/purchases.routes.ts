import {Router} from "express";
import {authenticate} from "../middlewares/auth.middleware";
import {createPurchaseController} from "../controllers/purchases.controller";

const router = Router();

router.post("/create", authenticate, createPurchaseController);

export default router;