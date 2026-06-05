import { Link } from "@tanstack/react-router";
import { motion } from "framer-motion";
import type { Product } from "@/data/products";

export function ProductCard({ product, index = 0 }: { product: Product; index?: number }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.35, delay: index * 0.04, ease: [0.22, 1, 0.36, 1] }}
    >
      <Link
        to="/product/$id"
        params={{ id: product.id }}
        className="group block overflow-hidden rounded-2xl bg-surface shadow-soft transition-shadow hover:shadow-card"
      >
        <div className="aspect-square overflow-hidden bg-secondary">
          <img
            src={product.image}
            alt={product.name}
            width={768}
            height={768}
            loading="lazy"
            className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
          />
        </div>
        <div className="p-3">
          <p className="text-[11px] uppercase tracking-wider text-muted-foreground">
            {product.category}
          </p>
          <h3 className="mt-0.5 truncate text-sm font-semibold">{product.name}</h3>
          <p className="mt-1 text-sm font-semibold tabular-nums">${product.price.toLocaleString("en-US")}</p>
        </div>
      </Link>
    </motion.div>
  );
}
