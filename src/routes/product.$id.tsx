import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { ChevronLeft, Heart, Star, ShoppingBag } from "lucide-react";
import { motion } from "framer-motion";
import { useState } from "react";
import { PhoneShell } from "@/components/PhoneShell";
import { getProduct } from "@/data/products";
import { useCart } from "@/store/cart";
import { toast } from "sonner";

export const Route = createFileRoute("/product/$id")({
  head: ({ params }) => {
    const p = getProduct(params.id);
    return {
      meta: [
        { title: `${p?.name ?? "Товар"} — Voltix` },
        { name: "description", content: p?.tagline ?? "Товар Voltix" },
      ],
    };
  },
  component: ProductPage,
  notFoundComponent: () => (
    <div className="grid min-h-dvh place-items-center">Товар не знайдено</div>
  ),
});

function ProductPage() {
  const { id } = Route.useParams();
  const product = getProduct(id);
  const add = useCart((s) => s.add);
  const navigate = useNavigate();
  const [color, setColor] = useState(0);

  if (!product) {
    return (
      <PhoneShell>
        <div className="grid flex-1 place-items-center p-6 text-center">
          <p className="text-sm text-muted-foreground">Товар не знайдено</p>
        </div>
      </PhoneShell>
    );
  }

  return (
    <PhoneShell>
      <div className="flex flex-1 flex-col overflow-y-auto">
        <div className="relative bg-secondary">
          <div className="flex items-center justify-between p-4">
            <button
              onClick={() => navigate({ to: "/catalog" })}
              className="grid h-10 w-10 place-items-center rounded-full bg-surface shadow-soft"
            >
              <ChevronLeft size={20} />
            </button>
            <button className="grid h-10 w-10 place-items-center rounded-full bg-surface shadow-soft">
              <Heart size={18} />
            </button>
          </div>
          <motion.img
            initial={{ opacity: 0, scale: 0.92 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
            src={product.image}
            alt={product.name}
            width={768}
            height={768}
            className="mx-auto h-72 w-72 object-contain"
          />
        </div>

        <div className="-mt-4 flex-1 rounded-t-3xl bg-surface p-5">
          <p className="text-[11px] uppercase tracking-widest text-muted-foreground">
            {product.category}
          </p>
          <h1 className="mt-1 text-2xl font-semibold leading-tight">{product.name}</h1>
          <p className="mt-1 text-sm text-muted-foreground">{product.tagline}</p>

          <div className="mt-3 flex items-center gap-2 text-xs">
            <Star size={14} className="fill-foreground" />
            <span className="font-semibold">{product.rating}</span>
            <span className="text-muted-foreground">({product.reviews} відгуків)</span>
          </div>

          <div className="mt-5">
            <p className="text-xs font-medium text-muted-foreground">Колір</p>
            <div className="mt-2 flex gap-2">
              {product.colors.map((c, i) => (
                <button
                  key={c}
                  onClick={() => setColor(i)}
                  className="h-8 w-8 rounded-full border-2 transition-all"
                  style={{
                    background: c,
                    borderColor: color === i ? "var(--color-primary)" : "transparent",
                  }}
                />
              ))}
            </div>
          </div>

          <div className="mt-5">
            <p className="text-xs font-medium text-muted-foreground">Опис</p>
            <p className="mt-2 text-sm leading-relaxed">{product.description}</p>
          </div>
        </div>

        <div className="sticky bottom-0 border-t border-border bg-surface/95 p-4 backdrop-blur-xl">
          <div className="flex items-center gap-3">
            <div>
              <p className="text-[11px] text-muted-foreground">Ціна</p>
              <p className="text-lg font-semibold tabular-nums">
                ${product.price.toLocaleString("en-US")}
              </p>
            </div>
            <button
              onClick={() => {
                add(product);
                toast.success("Додано в кошик", { description: product.name });
              }}
              className="ml-auto flex flex-1 items-center justify-center gap-2 rounded-full bg-primary py-3.5 text-sm font-semibold text-primary-foreground transition-transform active:scale-[0.98]"
            >
              <ShoppingBag size={16} />
              Додати в кошик
            </button>
          </div>
          <Link
            to="/cart"
            className="mt-2 block text-center text-xs text-muted-foreground"
          >
            Перейти в кошик →
          </Link>
        </div>
      </div>
    </PhoneShell>
  );
}
