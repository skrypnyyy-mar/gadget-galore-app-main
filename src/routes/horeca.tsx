import { createFileRoute, Link } from "@tanstack/react-router";
import { ChevronLeft, Search, Truck } from "lucide-react";
import { motion } from "framer-motion";
import { useMemo, useState } from "react";
import { PhoneShell } from "@/components/PhoneShell";
import {
  horecaCategories,
  horecaItems,
  formatUSD,
  type HorecaCategory,
} from "@/data/horeca";

export const Route = createFileRoute("/horeca")({
  head: () => ({
    meta: [
      { title: "HoReCa — професійне обладнання для закладів" },
      {
        name: "description",
        content:
          "Каталог HoReCa-обладнання: кавомашини, печі, холодильне. Оренда та купівля з доставкою.",
      },
      { property: "og:title", content: "HoReCa — професійне обладнання" },
      {
        property: "og:description",
        content: "Каталог обладнання для ресторанів і кав'ярень.",
      },
    ],
  }),
  component: HorecaHome,
});

function HorecaHome() {
  const [q, setQ] = useState("");
  const [cat, setCat] = useState<HorecaCategory | "Усі">("Усі");

  const list = useMemo(
    () =>
      horecaItems.filter((i) => {
        const okCat = cat === "Усі" || i.category === cat;
        const okQ =
          i.name.toLowerCase().includes(q.toLowerCase()) ||
          i.brand.toLowerCase().includes(q.toLowerCase());
        return okCat && okQ;
      }),
    [q, cat],
  );

  return (
    <PhoneShell>
      <main className="flex-1 overflow-y-auto pb-10">
        <header className="px-5 pt-6">
          <div className="flex items-center gap-3">
            <Link
              to="/"
              className="grid h-10 w-10 place-items-center rounded-full bg-secondary"
            >
              <ChevronLeft size={20} />
            </Link>
            <div className="min-w-0">
              <p className="text-[11px] uppercase tracking-widest text-muted-foreground">
                Voltix · HoReCa
              </p>
              <h1 className="truncate text-xl font-semibold">Обладнання для закладу</h1>
            </div>
          </div>

          <div className="mt-5 flex items-center gap-2 rounded-2xl bg-secondary px-4 py-3">
            <Search size={18} className="text-muted-foreground" />
            <input
              value={q}
              onChange={(e) => setQ(e.target.value)}
              placeholder="Пошук моделі або бренду..."
              className="w-full bg-transparent text-sm outline-none placeholder:text-muted-foreground"
            />
          </div>
        </header>

        <motion.section
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.45, ease: [0.22, 1, 0.36, 1] }}
          className="mx-5 mt-5 overflow-hidden rounded-3xl bg-primary p-5 text-primary-foreground"
        >
          <p className="text-[11px] uppercase tracking-widest opacity-70">Сервіс</p>
          <h2 className="mt-1 text-lg font-semibold leading-snug">
            Безкоштовна доставка та монтаж по місту
          </h2>
          <p className="mt-1 text-xs opacity-75">
            Замовляйте обладнання онлайн — бронюємо дату й привозимо.
          </p>
          <div className="mt-3 inline-flex items-center gap-2 rounded-full bg-surface px-3 py-1.5 text-[11px] font-semibold text-foreground">
            <Truck size={12} /> від 24 годин
          </div>
        </motion.section>

        <section className="mt-6">
          <div className="no-scrollbar flex gap-2 overflow-x-auto px-5">
            {(["Усі", ...horecaCategories.map((c) => c.id)] as const).map((c) => {
              const meta = horecaCategories.find((x) => x.id === c);
              const active = cat === c;
              return (
                <button
                  key={c}
                  onClick={() => setCat(c as HorecaCategory | "Усі")}
                  className="whitespace-nowrap rounded-full px-4 py-2 text-xs font-medium transition-colors"
                  style={{
                    background: active
                      ? "var(--color-primary)"
                      : "var(--color-secondary)",
                    color: active
                      ? "var(--color-primary-foreground)"
                      : "var(--color-foreground)",
                  }}
                >
                  {meta ? `${meta.emoji} ${c}` : c}
                </button>
              );
            })}
          </div>
        </section>

        <section className="mt-5 px-5">
          {list.length === 0 ? (
            <p className="py-16 text-center text-sm text-muted-foreground">
              Нічого не знайдено
            </p>
          ) : (
            <div className="grid grid-cols-2 gap-3">
              {list.map((item, i) => (
                <motion.div
                  key={item.id}
                  initial={{ opacity: 0, y: 12 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{
                    duration: 0.35,
                    delay: i * 0.04,
                    ease: [0.22, 1, 0.36, 1],
                  }}
                >
                  <Link
                    to="/horeca/$id"
                    params={{ id: item.id }}
                    className="group block overflow-hidden rounded-2xl bg-surface shadow-soft transition-shadow hover:shadow-card"
                  >
                    <div className="aspect-square overflow-hidden bg-secondary">
                      <img
                        src={item.image}
                        alt={item.name}
                        width={768}
                        height={768}
                        loading="lazy"
                        className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                      />
                    </div>
                    <div className="p-3">
                      <p className="text-[11px] uppercase tracking-wider text-muted-foreground">
                        {item.brand}
                      </p>
                      <h3 className="mt-0.5 truncate text-sm font-semibold">
                        {item.name}
                      </h3>
                      <div className="mt-1 flex items-baseline justify-between">
                        <p className="text-sm font-semibold tabular-nums">
                          ${formatUSD(item.priceBuy)}
                        </p>
                        <p className="text-[11px] text-muted-foreground tabular-nums">
                          ${formatUSD(item.pricePerDay)}/день
                        </p>
                      </div>
                    </div>
                  </Link>
                </motion.div>
              ))}
            </div>
          )}
        </section>
      </main>
    </PhoneShell>
  );
}
