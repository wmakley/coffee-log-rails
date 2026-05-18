import { Head, Link } from "@inertiajs/react";

const tabs = [
  { id: "dashboard", label: "Dashboard" },
  { id: "log-entries", label: "Log Entries" },
  { id: "my-account", label: "My Account" },
] as const;

export default function Tabs({
  active_tab,
  children,
}: {
  active_tab: string;
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-stone-100">
      <Head title="Coffee Log" />

      <div className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <header className="mb-8">
          <p className="text-sm font-medium tracking-wide text-amber-800/70 uppercase">
            Coffee Log
          </p>
          <h1 className="mt-1 text-3xl font-semibold tracking-tight text-stone-900">
            Good morning, William
          </h1>
          <p className="mt-2 text-stone-600">
            Your brew tracker for the week ahead.
          </p>
        </header>

        <div
          role="tablist"
          aria-label="Main navigation"
          className="flex gap-1 rounded-xl bg-stone-200/80 p-1 shadow-inner"
        >
          {tabs.map((tab) => (
            <Link
              key={tab.id}
              href={`/inertia/tabs/${tab.id}`}
              role="tab"
              aria-selected={tab.id === active_tab}
              className={
                tab.id === active_tab
                  ? "flex-1 rounded-lg bg-white px-4 py-2.5 text-center text-sm font-semibold text-amber-950 shadow-sm ring-1 ring-stone-900/5"
                  : "flex-1 rounded-lg px-4 py-2.5 text-center text-sm font-medium text-stone-500"
              }
            >
              {tab.label}
            </Link>
          ))}
        </div>

        <main className="mt-8 space-y-6">{children}</main>
      </div>
    </div>
  );
}
