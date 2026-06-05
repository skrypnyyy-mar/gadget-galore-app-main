import { createFileRoute, Link } from "@tanstack/react-router";
import { Search } from "lucide-react";
import { useState } from "react";
import { PhoneShell } from "@/components/PhoneShell";
import { BottomNav } from "@/components/BottomNav";
import { ProductCard } from "@/components/ProductCard";
import { products, categories } from "@/data/products";

export const Route = createFileRoute("/catalog")({
  head: () => ({
    meta: [
      { title: "Каталог — Voltix" },
      { name: "description", content: "Усі товари магазину техніки Voltix." },
    ],
  }),
  component: Catalog,
});

function Catalog() {
  const [q, setQ] = useState("");
  const [cat, setCat] = useState<(typeof categories)[number]>("All");

  const filtered = products.filter((p) => {
    const okCat = cat === "All" || p.category === cat;
    const okQ = p.name.toLowerCase().includes(q.toLowerCase());
    return okCat && okQ;
  });

  return (
    <PhoneShell>
      <main className="flex-1 overflow-y-auto pb-24">
        <header className="px-5 pt-6">
          <div className="flex items-center justify-between">
            <h1 className="text-2xl font-semibold">Каталог</h1>
            <Link to="/cart" className="text-xs font-medium text-accent">
              Кошик
            </Link>
          </div>

          <div className="mt-4 flex items-center gap-2 rounded-2xl bg-secondary px-4 py-3">
            <Search size={18} className="text-muted-foreground" />
            <input
              value={q}
              onChange={(e) => setQ(e.target.value)}
              placeholder="Пошук..."
              className="w-full bg-transparent text-sm outline-none placeholder:text-muted-foreground"
            />
          </div>

          <div className="no-scrollbar mt-4 flex gap-2 overflow-x-auto">
            {categories.map((c) => (
              <button
                key={c}
                onClick={() => setCat(c)}
                className="whitespace-nowrap rounded-full px-4 py-2 text-xs font-medium"
                style={{
                  background: cat === c ? "var(--color-primary)" : "var(--color-secondary)",
                  color: cat === c ? "var(--color-primary-foreground)" : "var(--color-foreground)",
                }}
              >
                {c}
              </button>
            ))}
          </div>
        </header>

        <section className="mt-5 px-5">
          {filtered.length === 0 ? (
            <p className="py-16 text-center text-sm text-muted-foreground">
              Нічого не знайдено
            </p>
          ) : (
            <div className="grid grid-cols-2 gap-3">
              {filtered.map((p, i) => (
                <ProductCard key={p.id} product={p} index={i} />
              ))}
            </div>
          )}
        </section>
      </main>
      <BottomNav />
    </PhoneShell>
  );
}
