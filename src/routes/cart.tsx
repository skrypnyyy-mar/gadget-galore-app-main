import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { ChevronLeft, Minus, Plus, Trash2, ShoppingBag } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { PhoneShell } from "@/components/PhoneShell";
import { useCart } from "@/store/cart";

export const Route = createFileRoute("/cart")({
  head: () => ({
    meta: [
      { title: "Кошик — Voltix" },
      { name: "description", content: "Ваш кошик у Voltix." },
    ],
  }),
  component: Cart,
});

function Cart() {
  const items = useCart((s) => s.items);
  const setQty = useCart((s) => s.setQty);
  const remove = useCart((s) => s.remove);
  const subtotal = useCart((s) => s.subtotal());
  const navigate = useNavigate();

  const shipping = items.length ? 15 : 0;
  const total = subtotal + shipping;

  return (
    <PhoneShell>
      <header className="flex items-center gap-3 px-5 pt-6">
        <button
          onClick={() => navigate({ to: "/catalog" })}
          className="grid h-10 w-10 place-items-center rounded-full bg-secondary"
        >
          <ChevronLeft size={20} />
        </button>
        <h1 className="text-xl font-semibold">Кошик</h1>
        <span className="ml-auto text-xs text-muted-foreground">
          {items.length} {items.length === 1 ? "товар" : "товарів"}
        </span>
      </header>

      <main className="flex-1 overflow-y-auto px-5 pb-40 pt-5">
        {items.length === 0 ? (
          <div className="grid place-items-center py-20 text-center">
            <div className="grid h-16 w-16 place-items-center rounded-full bg-secondary">
              <ShoppingBag size={24} className="text-muted-foreground" />
            </div>
            <p className="mt-4 text-sm font-medium">Кошик порожній</p>
            <p className="mt-1 text-xs text-muted-foreground">Додайте товари з каталогу</p>
            <Link
              to="/catalog"
              className="mt-5 rounded-full bg-primary px-5 py-2.5 text-xs font-semibold text-primary-foreground"
            >
              До каталогу
            </Link>
          </div>
        ) : (
          <ul className="space-y-3">
            <AnimatePresence>
              {items.map((item) => (
                <motion.li
                  key={item.product.id}
                  layout
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, x: -40 }}
                  className="flex gap-3 rounded-2xl bg-surface p-3 shadow-soft"
                >
                  <div className="h-20 w-20 shrink-0 overflow-hidden rounded-xl bg-secondary">
                    <img
                      src={item.product.image}
                      alt={item.product.name}
                      width={768}
                      height={768}
                      loading="lazy"
                      className="h-full w-full object-cover"
                    />
                  </div>
                  <div className="flex flex-1 flex-col">
                    <div className="flex items-start justify-between gap-2">
                      <div>
                        <h3 className="text-sm font-semibold leading-tight">
                          {item.product.name}
                        </h3>
                        <p className="mt-0.5 text-[11px] text-muted-foreground">
                          {item.product.category}
                        </p>
                      </div>
                      <button
                        onClick={() => remove(item.product.id)}
                        className="text-muted-foreground"
                        aria-label="Видалити"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                    <div className="mt-auto flex items-center justify-between">
                      <p className="text-sm font-semibold tabular-nums">
                        ${(item.product.price * item.quantity).toLocaleString("en-US")}
                      </p>
                      <div className="flex items-center gap-1 rounded-full bg-secondary p-1">
                        <button
                          onClick={() => setQty(item.product.id, item.quantity - 1)}
                          className="grid h-7 w-7 place-items-center rounded-full bg-surface"
                        >
                          <Minus size={12} />
                        </button>
                        <span className="w-5 text-center text-xs font-semibold tabular-nums">
                          {item.quantity}
                        </span>
                        <button
                          onClick={() => setQty(item.product.id, item.quantity + 1)}
                          className="grid h-7 w-7 place-items-center rounded-full bg-surface"
                        >
                          <Plus size={12} />
                        </button>
                      </div>
                    </div>
                  </div>
                </motion.li>
              ))}
            </AnimatePresence>
          </ul>
        )}
      </main>

      {items.length > 0 && (
        <div className="sticky bottom-0 border-t border-border bg-surface/95 p-5 backdrop-blur-xl">
          <dl className="space-y-1.5 text-sm">
            <div className="flex justify-between text-muted-foreground">
              <dt>Сума</dt>
              <dd className="tabular-nums">${subtotal.toLocaleString("en-US")}</dd>
            </div>
            <div className="flex justify-between text-muted-foreground">
              <dt>Доставка</dt>
              <dd className="tabular-nums">${shipping}</dd>
            </div>
            <div className="flex justify-between pt-1 text-base font-semibold">
              <dt>Разом</dt>
              <dd className="tabular-nums">${total.toLocaleString("en-US")}</dd>
            </div>
          </dl>
          <Link
            to="/checkout"
            className="mt-4 block rounded-full bg-primary py-3.5 text-center text-sm font-semibold text-primary-foreground"
          >
            Оформити замовлення
          </Link>
        </div>
      )}
    </PhoneShell>
  );
}
