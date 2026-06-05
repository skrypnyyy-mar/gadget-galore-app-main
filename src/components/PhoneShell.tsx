import { ReactNode } from "react";

export function PhoneShell({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-dvh bg-muted/40 py-0 sm:py-6">
      <div className="phone-shell relative flex flex-col">{children}</div>
    </div>
  );
}
