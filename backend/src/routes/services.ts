import { Router } from 'express';
import { authenticate } from '../middlewares/auth';

const router = Router();

router.get('/', authenticate, (req: any, res: any) => {
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
