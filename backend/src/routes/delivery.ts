import { Router, Request, Response } from 'express';

const router = Router();

// Mock rules for delivery calculation based on category
const getDeliveryCost = (category: string) => {
  const heavyItems = ['Холодильники', 'Печі', 'Пральні машини', 'Посудомийки'];
  if (heavyItems.includes(category)) return 500; // 500 UAH for heavy items
  return 100; // 100 UAH standard delivery
};

router.post('/estimate', (req: Request, res: Response) => {
  try {
    const { items } = req.body; // Array of { category: string, quantity: number }
    if (!items || !items.length) {
      return res.json({ cost: 0, estimatedDays: 1 });
    }

    let maxCost = 0;
    let hasHeavy = false;

    for (const item of items) {
      const cost = getDeliveryCost(item.category);
      if (cost > maxCost) maxCost = cost;
      if (cost >= 500) hasHeavy = true;
    }

    res.json({
      cost: maxCost,
      estimatedDays: hasHeavy ? 3 : 1 // Heavy items take 3 days, normal 1 day
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error calculating delivery' });
  }
});

export default router;
