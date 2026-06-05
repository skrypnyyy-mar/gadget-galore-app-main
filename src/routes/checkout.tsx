import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { ChevronLeft, CreditCard, Truck, Apple } from "lucide-react";
import { useState } from "react";
import { PhoneShell } from "@/components/PhoneShell";
import { useCart } from "@/store/cart";
import { toast } from "sonner";

export const Route = createFileRoute("/checkout")({
  head: () => ({
    meta: [
      { title: "Оформлення — Voltix" },
      { name: "description", content: "Оформлення замовлення Voltix." },
    ],
  }),
  component: Checkout,
});

function Checkout() {
  const navigate = useNavigate();
  const subtotal = useCart((s) => s.subtotal());
  const items = useCart((s) => s.items);
  const clear = useCart((s) => s.clear);
  const total = subtotal + (items.length ? 15 : 0);

  const [pay, setPay] = useState<"card" | "apple">("card");
  const [loading, setLoading] = useState(false);

  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      clear();
      toast.success("Замовлення оформлено!");
      navigate({ to: "/success" });
    }, 1100);
  };

  return (
    <PhoneShell>
      <header className="flex items-center gap-3 px-5 pt-6">
        <button
          onClick={() => navigate({ to: "/cart" })}
          className="grid h-10 w-10 place-items-center rounded-full bg-secondary"
        >
          <ChevronLeft size={20} />
        </button>
        <h1 className="text-xl font-semibold">Оформлення</h1>
      </header>

      <form onSubmit={submit} className="flex-1 overflow-y-auto px-5 pb-32 pt-5">
        <section>
          <div className="mb-2 flex items-center gap-2">
            <Truck size={16} />
            <h2 className="text-sm font-semibold">Доставка</h2>
          </div>
          <div className="space-y-2">
            <Field label="Ім'я та прізвище" placeholder="Олександр Коваль" required />
            <Field label="Телефон" placeholder="+380 ..." type="tel" required />
            <Field label="Місто" placeholder="Київ" required />
            <Field label="Адреса" placeholder="вул. Хрещатик, 1" required />
          </div>
        </section>

        <section className="mt-6">
          <div className="mb-2 flex items-center gap-2">
            <CreditCard size={16} />
            <h2 className="text-sm font-semibold">Оплата</h2>
          </div>

          <div className="grid grid-cols-2 gap-2">
            <button
              type="button"
              onClick={() => setPay("card")}
              className="flex items-center justify-center gap-2 rounded-2xl border-2 py-3 text-xs font-semibold transition-colors"
              style={{
                borderColor: pay === "card" ? "var(--color-primary)" : "var(--color-border)",
                background: pay === "card" ? "var(--color-secondary)" : "var(--color-surface)",
              }}
            >
              <CreditCard size={14} /> Картка
            </button>
            <button
              type="button"
              onClick={() => setPay("apple")}
              className="flex items-center justify-center gap-2 rounded-2xl border-2 py-3 text-xs font-semibold transition-colors"
              style={{
                borderColor: pay === "apple" ? "var(--color-primary)" : "var(--color-border)",
                background: pay === "apple" ? "var(--color-secondary)" : "var(--color-surface)",
              }}
            >
              <Apple size={14} /> Apple Pay
            </button>
          </div>

          {pay === "card" && (
            <div className="mt-3 space-y-2">
              <Field label="Номер картки" placeholder="4242 4242 4242 4242" inputMode="numeric" required />
              <div className="grid grid-cols-2 gap-2">
                <Field label="MM / YY" placeholder="12 / 27" required />
                <Field label="CVC" placeholder="123" inputMode="numeric" required />
              </div>
            </div>
          )}
        </section>

        <div className="sticky bottom-0 -mx-5 mt-6 border-t border-border bg-surface/95 px-5 py-4 backdrop-blur-xl">
          <div className="flex items-center justify-between text-sm">
            <span className="text-muted-foreground">До оплати</span>
            <span className="text-lg font-semibold tabular-nums">
              ${total.toLocaleString("en-US")}
            </span>
          </div>
          <button
            type="submit"
            disabled={loading || items.length === 0}
            className="mt-3 block w-full rounded-full bg-primary py-3.5 text-center text-sm font-semibold text-primary-foreground disabled:opacity-50"
          >
            {loading ? "Обробка..." : "Сплатити"}
          </button>
        </div>
      </form>
    </PhoneShell>
  );
}

function Field({
  label,
  ...props
}: { label: string } & React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <label className="block">
      <span className="text-[11px] font-medium text-muted-foreground">{label}</span>
      <input
        {...props}
        className="mt-1 w-full rounded-xl border border-input bg-surface px-3.5 py-3 text-sm outline-none transition-colors focus:border-primary"
      />
    </label>
  );
}
