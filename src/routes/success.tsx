import { createFileRoute, Link } from "@tanstack/react-router";
import { Check } from "lucide-react";
import { motion } from "framer-motion";
import { PhoneShell } from "@/components/PhoneShell";

export const Route = createFileRoute("/success")({
  head: () => ({
    meta: [{ title: "Дякуємо — Voltix" }],
  }),
  component: Success,
});

function Success() {
  return (
    <PhoneShell>
      <div className="grid flex-1 place-items-center px-6 text-center">
        <div>
          <motion.div
            initial={{ scale: 0, rotate: -90 }}
            animate={{ scale: 1, rotate: 0 }}
            transition={{ type: "spring", stiffness: 220, damping: 18 }}
            className="mx-auto grid h-20 w-20 place-items-center rounded-full bg-primary text-primary-foreground"
          >
            <Check size={36} strokeWidth={2.5} />
          </motion.div>
          <h1 className="mt-6 text-2xl font-semibold">Замовлення прийнято</h1>
          <p className="mt-2 text-sm text-muted-foreground">
            Ми надіслали підтвердження на пошту. Очікуйте дзвінка кур'єра.
          </p>
          <Link
            to="/"
            className="mt-8 inline-block rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground"
          >
            На головну
          </Link>
        </div>
      </div>
    </PhoneShell>
  );
}
