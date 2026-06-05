import { createFileRoute, Link } from "@tanstack/react-router";
import { Heart } from "lucide-react";
import { PhoneShell } from "@/components/PhoneShell";
import { BottomNav } from "@/components/BottomNav";

export const Route = createFileRoute("/favorites")({
  head: () => ({ meta: [{ title: "Обране — Voltix" }] }),
  component: Favorites,
});

function Favorites() {
  return (
    <PhoneShell>
      <main className="flex-1 px-5 pt-6">
        <h1 className="text-2xl font-semibold">Обране</h1>
        <div className="mt-16 grid place-items-center text-center">
          <div className="grid h-16 w-16 place-items-center rounded-full bg-secondary">
            <Heart size={24} className="text-muted-foreground" />
          </div>
          <p className="mt-4 text-sm font-medium">Поки порожньо</p>
          <p className="mt-1 text-xs text-muted-foreground">
            Зберігайте товари сюди, щоб не загубити
          </p>
          <Link
            to="/catalog"
            className="mt-5 rounded-full bg-primary px-5 py-2.5 text-xs font-semibold text-primary-foreground"
          >
            До каталогу
          </Link>
        </div>
      </main>
      <BottomNav />
    </PhoneShell>
  );
}
