import {Router} from 'express';
import {authenticate} from '../middlewares/auth.middleware';
import { handleCreateBatch } from '../controllers/batch.controller';
import { getBatchListController } from '../controllers/batch.controller';

const router = Router();

router.post('/create', authenticate, handleCreateBatch);
router.get('/batchList', authenticate, getBatchListController);

export default router;