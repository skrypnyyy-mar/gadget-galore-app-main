import { Request, Response, NextFunction } from 'express';

export const validateBody = (requiredFields: string[]) => {
  return (req: Request, res: Response, next: NextFunction): any => {
    const missing = requiredFields.filter((field) => !req.body || req.body[field] === undefined);
    if (missing.length > 0) {
      return res.status(400).json({ error: `Missing fields: ${missing.join(', ')}` });
    }
    next();
  };
};
