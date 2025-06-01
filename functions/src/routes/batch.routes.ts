import {Router} from 'express';
import {authenticate} from '../middlewares/auth.middleware';
import { handleCreateBatch } from '../controllers/batch.controller';

const router = Router();

router.post('/create', authenticate, handleCreateBatch);

export default router;