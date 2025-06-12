import {Router} from 'express';
import {authenticate} from '../middlewares/auth.middleware';
import { createBuyerController } from '../controllers/buyer.controller';
import { getBuyersController } from '../controllers/buyer.controller';
import { getBuyerController } from '../controllers/buyer.controller';

const router = Router();

router.post('/create', authenticate, createBuyerController);
router.get('/get-buyers', authenticate, getBuyersController);
router.get('/get-buyer/:buyerId', authenticate, getBuyerController);

export default router;