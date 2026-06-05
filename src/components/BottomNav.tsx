import { Link, useLocation } from "@tanstack/react-router";
import { Home, ShoppingBag, Heart, User } from "lucide-react";
import { useCart } from "@/store/cart";

const tabs = [
  { to: "/", label: "Home", icon: Home },
  { to: "/catalog", label: "Shop", icon: ShoppingBag },
  { to: "/favorites", label: "Saved", icon: Heart },
  { to: "/account", label: "Account", icon: User },
] as const;

export function BottomNav() {
  const location = useLocation();
  const count = useCart((s) => s.count());

  return (
    <nav className="sticky bottom-0 z-30 border-t border-border bg-surface/90 backdrop-blur-xl">
      <div className="grid grid-cols-4 px-2 pb-3 pt-2">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const active =
            tab.to === "/"
              ? location.pathname === "/"
              : location.pathname.startsWith(tab.to);
          return (
            <Link
              key={tab.to}
              to={tab.to}
              className="relative flex flex-col items-center gap-1 py-1.5 text-[11px] font-medium"
              style={{ color: active ? "var(--color-primary)" : "var(--color-muted-foreground)" }}
            >
              <span className="relative">
                <Icon size={22} strokeWidth={active ? 2.4 : 1.8} />
                {tab.to === "/catalog" && count > 0 && (
                  <span className="absolute -right-2 -top-1.5 grid h-4 min-w-4 place-items-center rounded-full bg-accent px-1 text-[10px] font-semibold text-accent-foreground">
                    {count}
                  </span>
                )}
              </span>
              {tab.label}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
