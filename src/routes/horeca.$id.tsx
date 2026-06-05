import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { ChevronLeft, CalendarDays, ShieldCheck, Zap, Ruler } from "lucide-react";
import { motion } from "framer-motion";
import { PhoneShell } from "@/components/PhoneShell";
import { getHorecaItem, formatUSD } from "@/data/horeca";

export const Route = createFileRoute("/horeca/$id")({
  head: ({ params }) => {
    const item = getHorecaItem(params.id);
    return {
      meta: [
        { title: `${item?.name ?? "Обладнання"} — HoReCa` },
        { name: "description", content: item?.tagline ?? "Обладнання HoReCa" },
        { property: "og:title", content: `${item?.name ?? "Обладнання"} — HoReCa` },
        { property: "og:description", content: item?.tagline ?? "Обладнання HoReCa" },
      ],
    };
  },
  component: HorecaItemPage,
  notFoundComponent: () => (
    <div className="grid min-h-dvh place-items-center">Обладнання не знайдено</div>
  ),
});

function HorecaItemPage() {
  const { id } = Route.useParams();
  const navigate = useNavigate();
  const item = getHorecaItem(id);

  if (!item) {
    return (
      <PhoneShell>
        <div className="grid flex-1 place-items-center p-6 text-center">
          <p className="text-sm text-muted-foreground">Не знайдено</p>
        </div>
      </PhoneShell>
    );
  }

  return (
    <PhoneShell>
      <div className="flex flex-1 flex-col overflow-y-auto pb-28">
        <div className="relative bg-secondary">
          <div className="flex items-center justify-between p-4">
            <button
              onClick={() => navigate({ to: "/horeca" })}
              className="grid h-10 w-10 place-items-center rounded-full bg-surface shadow-soft"
            >
              <ChevronLeft size={20} />
            </button>
            <span className="rounded-full bg-surface px-3 py-1 text-[11px] font-semibold shadow-soft">
              {item.category}
            </span>
          </div>
          <motion.img
            initial={{ opacity: 0, scale: 0.92 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
            src={item.image}
            alt={item.name}
            width={768}
            height={768}
            className="mx-auto h-72 w-72 object-contain"
          />
        </div>

        <div className="-mt-4 flex-1 rounded-t-3xl bg-surface p-5">
          <p className="text-[11px] uppercase tracking-widest text-muted-foreground">
            {item.brand}
          </p>
          <h1 className="mt-1 text-2xl font-semibold leading-tight">{item.name}</h1>
          <p className="mt-1 text-sm text-muted-foreground">{item.tagline}</p>

          <div className="mt-4 grid grid-cols-2 gap-2">
            <div className="rounded-2xl bg-secondary p-3">
              <p className="text-[11px] text-muted-foreground">Купівля</p>
              <p className="text-lg font-semibold tabular-nums">
                ${formatUSD(item.priceBuy)}
              </p>
            </div>
            <div className="rounded-2xl bg-secondary p-3">
              <p className="text-[11px] text-muted-foreground">Оренда</p>
              <p className="text-lg font-semibold tabular-nums">
                ${formatUSD(item.pricePerDay)}
                <span className="text-xs font-normal text-muted-foreground"> /день</span>
              </p>
            </div>
          </div>

          <div className="mt-5 grid grid-cols-3 gap-2 text-center">
            <Stat icon={<Zap size={14} />} label="Потужність" value={item.power} />
            <Stat icon={<Ruler size={14} />} label="Габарити" value={item.dimensions} />
            <Stat icon={<ShieldCheck size={14} />} label="Гарантія" value={item.warranty} />
          </div>

          <div className="mt-5">
            <p className="text-xs font-medium text-muted-foreground">Опис</p>
            <p className="mt-2 text-sm leading-relaxed">{item.description}</p>
          </div>

          <div className="mt-5">
            <p className="text-xs font-medium text-muted-foreground">Характеристики</p>
            <dl className="mt-2 divide-y divide-border rounded-2xl bg-secondary px-4">
              {item.specs.map((s) => (
                <div key={s.label} className="flex justify-between py-2.5 text-sm">
                  <dt className="text-muted-foreground">{s.label}</dt>
                  <dd className="font-medium">{s.value}</dd>
                </div>
              ))}
            </dl>
          </div>
        </div>

        <div className="sticky bottom-0 border-t border-border bg-surface/95 p-4 backdrop-blur-xl">
          <Link
            to="/horeca/booking/$id"
            params={{ id: item.id }}
            className="flex items-center justify-center gap-2 rounded-full bg-primary py-3.5 text-sm font-semibold text-primary-foreground transition-transform active:scale-[0.98]"
          >
            <CalendarDays size={16} />
            Забронювати доставку
          </Link>
        </div>
      </div>
    </PhoneShell>
  );
}

function Stat({
  icon,
  label,
  value,
}: {
  icon: React.ReactNode;
  label: string;
  value: string;
}) {
  return (
    <div className="rounded-2xl border border-border p-2.5">
      <div className="mx-auto grid h-7 w-7 place-items-center rounded-full bg-secondary text-muted-foreground">
        {icon}
      </div>
      <p className="mt-1 text-[10px] uppercase tracking-wider text-muted-foreground">
        {label}
      </p>
      <p className="text-[11px] font-semibold leading-tight">{value}</p>
    </div>
  );
}
