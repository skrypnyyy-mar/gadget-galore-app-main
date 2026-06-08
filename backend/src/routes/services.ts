import { Router, Response } from 'express';
import { authenticate, AuthenticatedRequest } from '../middlewares/auth';

const router = Router();

router.get('/', authenticate, (req: AuthenticatedRequest, res: Response) => {
  res.json([
    {
      id: "install-basic",
      name: "Базовий монтаж",
      description: "Підключення та запуск техніки.",
      status: "В процесі"
    },
    {
      id: "service-plan",
      name: "Планове ТО",
      description: "Профілактика 4 рази на рік.",
      status: "Активне"
    }
  ]);
});

export default router;
