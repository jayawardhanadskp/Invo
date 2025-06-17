import {Router} from "express";
import {authenticate} from "../middlewares/auth.middleware";
import {createPurchaseController} from "../controllers/purchases.controller";
import {getPurchaseListController} from "../controllers/purchases.controller";

const router = Router();

router.post("/create", authenticate, createPurchaseController);
router.get('/purchaseList', authenticate, getPurchaseListController);

export default router;