import { Router } from "express"
import { authenticate } from "../middlewares/auth.middleware"
import { getAllDuesController } from "../controllers/due.controller"
import { getBuyersWithDueController } from "../controllers/due.controller"

const router = Router();

router.get("/dueCount", authenticate, getAllDuesController);
router.get("/dueList", authenticate, getBuyersWithDueController);

export default router;