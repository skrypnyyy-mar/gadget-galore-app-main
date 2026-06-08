import { Router, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { authenticate, AuthenticatedRequest } from '../middlewares/auth';

const router = Router();
const prisma = new PrismaClient();

router.get('/', authenticate, async (req: AuthenticatedRequest, res: Response): Promise<any> => {
  try {
    if (!req.userId) return res.status(401).json({ error: 'Unauthorized' });
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

router.put('/', authenticate, async (req: AuthenticatedRequest, res: Response): Promise<any> => {
  try {
    if (!req.userId) return res.status(401).json({ error: 'Unauthorized' });
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
