import { createFileRoute, Link } from "@tanstack/react-router";
import { Search, Bell } from "lucide-react";
import { motion } from "framer-motion";
import { PhoneShell } from "@/components/PhoneShell";
import { BottomNav } from "@/components/BottomNav";
import { ProductCard } from "@/components/ProductCard";
import { products, categories } from "@/data/products";
import { useState } from "react";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "Voltix — техніка майбутнього у твоїй кишені" },
      { name: "description", content: "Прототип мобільного магазину преміум-техніки: смартфони, ноутбуки, аудіо." },
    ],
  }),
  component: Index,
});

function Index() {
  const [cat, setCat] = useState<(typeof categories)[number]>("All");
  const featured = products[0];
  const list = cat === "All" ? products : products.filter((p) => p.category === cat);

  return (
    <PhoneShell>
      <main className="flex-1 overflow-y-auto pb-24">
        {/* Header */}
        <header className="px-5 pt-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs text-muted-foreground">Доброго дня</p>
              <h1 className="text-xl font-semibold">Олександре 👋</h1>
            </div>
            <button className="grid h-10 w-10 place-items-center rounded-full bg-secondary text-foreground">
              <Bell size={18} />
            </button>
          </div>

          <Link
            to="/catalog"
            className="mt-5 flex items-center gap-2 rounded-2xl bg-secondary px-4 py-3 text-sm text-muted-foreground"
          >
            <Search size={18} />
            Пошук техніки, брендів...
          </Link>
        </header>

        {/* Hero */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
          className="mx-5 mt-6 overflow-hidden rounded-3xl bg-primary text-primary-foreground"
        >
          <div className="grid grid-cols-5 items-center">
            <div className="col-span-3 p-5">
              <p className="text-[11px] uppercase tracking-widest opacity-70">Новинка</p>
              <h2 className="mt-1 text-2xl font-semibold leading-tight">{featured.name}</h2>
              <p className="mt-1 text-xs opacity-75">{featured.tagline}</p>
              <Link
                to="/product/$id"
                params={{ id: featured.id }}
                className="mt-4 inline-flex rounded-full bg-surface px-4 py-2 text-xs font-semibold text-foreground"
              >
                Дивитись →
              </Link>
            </div>
            <div className="col-span-2">
              <img
                src={featured.image}
                alt={featured.name}
                width={768}
                height={768}
                className="h-36 w-full object-contain"
              />
            </div>
          </div>
        </motion.section>

        {/* HoReCa entry */}
        <Link
          to="/horeca"
          className="mx-5 mt-3 flex items-center gap-3 rounded-2xl border border-border bg-surface p-4"
        >
          <div className="grid h-11 w-11 place-items-center rounded-xl bg-secondary text-lg">
            👨‍🍳
          </div>
          <div className="min-w-0 flex-1">
            <p className="text-sm font-semibold">Voltix HoReCa</p>
            <p className="truncate text-xs text-muted-foreground">
              Обладнання для ресторанів і кав'ярень
            </p>
          </div>
          <span className="text-xs font-medium text-accent">Каталог →</span>
        </Link>

        {/* Categories */}
        <section className="mt-7">
          <div className="flex items-baseline justify-between px-5">
            <h3 className="text-base font-semibold">Категорії</h3>
            <Link to="/catalog" className="text-xs text-muted-foreground">
              Усі
            </Link>
          </div>
          <div className="no-scrollbar mt-3 flex gap-2 overflow-x-auto px-5">
            {categories.map((c) => (
              <button
                key={c}
                onClick={() => setCat(c)}
                className="whitespace-nowrap rounded-full px-4 py-2 text-xs font-medium transition-colors"
                style={{
                  background: cat === c ? "var(--color-primary)" : "var(--color-secondary)",
                  color: cat === c ? "var(--color-primary-foreground)" : "var(--color-foreground)",
                }}
              >
                {c}
              </button>
            ))}
          </div>
        </section>

        {/* Grid */}
        <section className="mt-6 px-5">
          <div className="grid grid-cols-2 gap-3">
            {list.map((p, i) => (
              <ProductCard key={p.id} product={p} index={i} />
            ))}
          </div>
        </section>
      </main>
      <BottomNav />
    </PhoneShell>
  );
}
