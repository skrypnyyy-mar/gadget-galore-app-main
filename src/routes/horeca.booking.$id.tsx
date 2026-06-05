import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { ChevronLeft, CalendarDays, MapPin, Building2, CheckCircle2 } from "lucide-react";
import { useMemo, useState } from "react";
import { PhoneShell } from "@/components/PhoneShell";
import { getHorecaItem, formatUSD } from "@/data/horeca";
import { toast } from "sonner";

export const Route = createFileRoute("/horeca/booking/$id")({
  head: ({ params }) => {
    const item = getHorecaItem(params.id);
    return {
      meta: [
        { title: `Бронювання — ${item?.name ?? "Обладнання"}` },
        {
          name: "description",
          content: "Бронювання доставки HoReCa-обладнання.",
        },
      ],
    };
  },
  component: BookingPage,
});

type Mode = "buy" | "rent";

function BookingPage() {
  const { id } = Route.useParams();
  const navigate = useNavigate();
  const item = getHorecaItem(id);

  const [mode, setMode] = useState<Mode>("rent");
  const [days, setDays] = useState(7);
  const [date, setDate] = useState("");
  const [slot, setSlot] = useState<"08-12" | "12-16" | "16-20">("12-16");
  const [done, setDone] = useState(false);
  const [loading, setLoading] = useState(false);

  const total = useMemo(() => {
    if (!item) return 0;
    return mode === "buy" ? item.priceBuy : item.pricePerDay * days;
  }, [item, mode, days]);

  if (!item) {
    return (
      <PhoneShell>
        <div className="grid flex-1 place-items-center p-6 text-center">
          <p className="text-sm text-muted-foreground">Обладнання не знайдено</p>
        </div>
      </PhoneShell>
    );
  }

  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setDone(true);
      toast.success("Бронювання прийнято!");
    }, 900);
  };

  if (done) {
    return (
      <PhoneShell>
        <div className="flex flex-1 flex-col items-center justify-center px-6 text-center">
          <div className="grid h-16 w-16 place-items-center rounded-full bg-primary text-primary-foreground">
            <CheckCircle2 size={32} />
          </div>
          <h1 className="mt-5 text-2xl font-semibold">Бронювання прийнято</h1>
          <p className="mt-2 text-sm text-muted-foreground">
            {item.name} · {date || "найближча дата"} · {slot}
          </p>
          <p className="mt-1 text-xs text-muted-foreground">
            Менеджер зв'яжеться з вами протягом 30 хвилин для підтвердження.
          </p>
          <div className="mt-8 w-full max-w-xs space-y-2">
            <button
              onClick={() => navigate({ to: "/horeca" })}
              className="w-full rounded-full bg-primary py-3 text-sm font-semibold text-primary-foreground"
            >
              До каталогу
            </button>
            <button
              onClick={() => navigate({ to: "/" })}
              className="w-full rounded-full bg-secondary py-3 text-sm font-semibold"
            >
              На головну
            </button>
          </div>
        </div>
      </PhoneShell>
    );
  }

  return (
    <PhoneShell>
      <header className="flex items-center gap-3 px-5 pt-6">
        <button
          onClick={() => navigate({ to: "/horeca/$id", params: { id } })}
          className="grid h-10 w-10 place-items-center rounded-full bg-secondary"
        >
          <ChevronLeft size={20} />
        </button>
        <div className="min-w-0">
          <p className="text-[11px] uppercase tracking-widest text-muted-foreground">
            Бронювання
          </p>
          <h1 className="truncate text-xl font-semibold">{item.name}</h1>
        </div>
      </header>

      <form onSubmit={submit} className="flex-1 overflow-y-auto px-5 pb-32 pt-5">
        <section>
          <p className="text-xs font-semibold text-muted-foreground">Тип</p>
          <div className="mt-2 grid grid-cols-2 gap-2">
            <ModeBtn active={mode === "rent"} onClick={() => setMode("rent")}>
              Оренда
              <span className="block text-[10px] font-normal text-muted-foreground">
                ${formatUSD(item.pricePerDay)}/день
              </span>
            </ModeBtn>
            <ModeBtn active={mode === "buy"} onClick={() => setMode("buy")}>
              Купівля
              <span className="block text-[10px] font-normal text-muted-foreground">
                ${formatUSD(item.priceBuy)}
              </span>
            </ModeBtn>
          </div>

          {mode === "rent" && (
            <div className="mt-3 rounded-2xl bg-secondary p-4">
              <div className="flex items-center justify-between">
                <span className="text-xs font-medium text-muted-foreground">
                  Кількість днів
                </span>
                <span className="text-sm font-semibold tabular-nums">{days}</span>
              </div>
              <input
                type="range"
                min={1}
                max={60}
                value={days}
                onChange={(e) => setDays(parseInt(e.target.value, 10))}
                className="mt-2 w-full accent-primary"
              />
              <div className="mt-1 flex justify-between text-[10px] text-muted-foreground">
                <span>1 день</span>
                <span>60 днів</span>
              </div>
            </div>
          )}
        </section>

        <section className="mt-6">
          <div className="mb-2 flex items-center gap-2">
            <CalendarDays size={16} />
            <h2 className="text-sm font-semibold">Дата та час доставки</h2>
          </div>
          <Field
            label="Дата"
            type="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
            required
          />
          <p className="mt-3 text-[11px] font-medium text-muted-foreground">
            Часовий слот
          </p>
          <div className="mt-2 grid grid-cols-3 gap-2">
            {(["08-12", "12-16", "16-20"] as const).map((s) => (
              <button
                key={s}
                type="button"
                onClick={() => setSlot(s)}
                className="rounded-2xl border-2 py-2.5 text-xs font-semibold transition-colors"
                style={{
                  borderColor:
                    slot === s ? "var(--color-primary)" : "var(--color-border)",
                  background:
                    slot === s ? "var(--color-secondary)" : "var(--color-surface)",
                }}
              >
                {s}
              </button>
            ))}
          </div>
        </section>

        <section className="mt-6">
          <div className="mb-2 flex items-center gap-2">
            <Building2 size={16} />
            <h2 className="text-sm font-semibold">Заклад</h2>
          </div>
          <div className="space-y-2">
            <Field label="Назва закладу" placeholder="Кав'ярня Brewbar" required />
            <Field label="Контактна особа" placeholder="Олена Шевченко" required />
            <Field label="Телефон" placeholder="+380 ..." type="tel" required />
          </div>
        </section>

        <section className="mt-6">
          <div className="mb-2 flex items-center gap-2">
            <MapPin size={16} />
            <h2 className="text-sm font-semibold">Адреса доставки</h2>
          </div>
          <div className="space-y-2">
            <Field label="Місто" placeholder="Київ" required />
            <Field label="Адреса" placeholder="вул. Хрещатик, 1" required />
            <Field label="Коментар" placeholder="Поверх, особливості заїзду..." />
          </div>
        </section>

        <div className="sticky bottom-0 -mx-5 mt-6 border-t border-border bg-surface/95 px-5 py-4 backdrop-blur-xl">
          <div className="flex items-center justify-between text-sm">
            <span className="text-muted-foreground">
              Сума ({mode === "rent" ? `${days} дн.` : "купівля"})
            </span>
            <span className="text-lg font-semibold tabular-nums">
              ${formatUSD(total)}
            </span>
          </div>
          <button
            type="submit"
            disabled={loading}
            className="mt-3 block w-full rounded-full bg-primary py-3.5 text-center text-sm font-semibold text-primary-foreground disabled:opacity-50"
          >
            {loading ? "Обробка..." : "Підтвердити бронювання"}
          </button>
        </div>
      </form>
    </PhoneShell>
  );
}

function ModeBtn({
  active,
  onClick,
  children,
}: {
  active: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="rounded-2xl border-2 py-3 text-sm font-semibold transition-colors"
      style={{
        borderColor: active ? "var(--color-primary)" : "var(--color-border)",
        background: active ? "var(--color-secondary)" : "var(--color-surface)",
      }}
    >
      {children}
    </button>
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
