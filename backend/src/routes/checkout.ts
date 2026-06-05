import { Router } from 'express';
import { PrismaClient } from '@prisma/client';
import jwt from 'jsonwebtoken';

const router = Router();
const prisma = new PrismaClient();
const JWT_SECRET = process.env.JWT_SECRET || 'super_secret_key';

// Middleware to authenticate
const authenticate = (req: any, res: any, next: any) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  try {
    const decoded = jwt.verify(token, JWT_SECRET) as any;
    req.userId = decoded.userId;
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
};

router.post('/', authenticate, async (req: any, res: any) => {
  try {
    const { items, total, deliveryCost, paymentMethod } = req.body;
    
    // Process payment here (mocked for now)
    if (paymentMethod !== 'card' && paymentMethod !== 'apple') {
      return res.status(400).json({ error: 'Invalid payment method' });
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
