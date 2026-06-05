import { Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { authenticate } from '../middlewares/auth';

const router = Router();
const prisma = new PrismaClient();

router.get('/', authenticate, async (req: any, res: any) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.userId },
      select: { id: true, email: true, name: true, phone: true, city: true, address: true }
    });
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(user);
  } catch {
    res.status(500).json({ error: 'Server error' });
  }
});

router.put('/', authenticate, async (req: any, res: any) => {
  try {
    const { name, phone, city, address } = req.body;
    const user = await prisma.user.update({
      where: { id: req.userId },
      data: { name, phone, city, address },
      select: { id: true, email: true, name: true, phone: true, city: true, address: true }
    });
    res.json(user);
  } catch {
    res.status(500).json({ error: 'Server error' });
  }
});

export default router;
