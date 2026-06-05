import { createFileRoute } from "@tanstack/react-router";
import { Package, MapPin, CreditCard, Settings, ChevronRight } from "lucide-react";
import { PhoneShell } from "@/components/PhoneShell";
import { BottomNav } from "@/components/BottomNav";

export const Route = createFileRoute("/account")({
  head: () => ({ meta: [{ title: "Акаунт — Voltix" }] }),
  component: Account,
});

const menu = [
  { icon: Package, label: "Мої замовлення" },
  { icon: MapPin, label: "Адреси доставки" },
  { icon: CreditCard, label: "Способи оплати" },
  { icon: Settings, label: "Налаштування" },
];

function Account() {
  return (
    <PhoneShell>
      <main className="flex-1 overflow-y-auto px-5 pt-6 pb-24">
        <h1 className="text-2xl font-semibold">Акаунт</h1>

        <div className="mt-5 flex items-center gap-3 rounded-2xl bg-surface p-4 shadow-soft">
          <div className="grid h-14 w-14 place-items-center rounded-full bg-primary text-primary-foreground text-lg font-semibold">
            О
          </div>
          <div>
            <p className="text-sm font-semibold">Олександр Коваль</p>
            <p className="text-xs text-muted-foreground">oleksandr@voltix.app</p>
          </div>
        </div>

        <ul className="mt-5 overflow-hidden rounded-2xl bg-surface shadow-soft">
          {menu.map((item, i) => {
            const Icon = item.icon;
            return (
              <li
                key={item.label}
                className="flex items-center gap-3 px-4 py-3.5"
                style={{ borderTop: i ? "1px solid var(--color-border)" : undefined }}
              >
                <Icon size={18} className="text-muted-foreground" />
                <span className="text-sm">{item.label}</span>
                <ChevronRight size={16} className="ml-auto text-muted-foreground" />
              </li>
            );
          })}
        </ul>
      </main>
      <BottomNav />
    </PhoneShell>
  );
}
