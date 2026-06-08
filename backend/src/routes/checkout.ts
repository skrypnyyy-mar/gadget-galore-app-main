import { Router, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { authenticate, AuthenticatedRequest } from '../middlewares/auth';
import { validateBody } from '../middlewares/validator';

const router = Router();
const prisma = new PrismaClient();

router.post('/', authenticate, validateBody(['items', 'total', 'deliveryCost', 'paymentMethod']), async (req: AuthenticatedRequest, res: Response): Promise<any> => {
  try {
    const { items, total, deliveryCost, paymentMethod } = req.body;
    
    // Process payment here (mocked for now)
    if (paymentMethod !== 'card' && paymentMethod !== 'apple') {
      return res.status(400).json({ error: 'Invalid payment method' });
    }

    if (!req.userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const order = await prisma.order.create({
      data: {
        userId: req.userId,
        total,
        deliveryCost,
        paymentMethod,
        items: {
          create: items.map((item: any) => ({
            productId: item.productId,
            name: item.name,
            quantity: item.quantity,
            price: item.price
          }))
        }
      },
      include: { items: true }
    });

    res.json({ message: 'Order placed successfully', order });
  } catch (error) {
    res.status(500).json({ error: 'Server error during checkout' });
  }
});

export default router;
