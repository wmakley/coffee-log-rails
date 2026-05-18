import { Head, Link } from "@inertiajs/react";

const tabs = [
  { id: "dashboard", label: "Dashboard" },
  { id: "log-entries", label: "Log Entries" },
  { id: "my-account", label: "My Account" },
] as const;

export default function Tabs({ active_tab }: { active_tab: string }) {
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
            <div
              key={tab.label}
              role="tab"
              aria-selected={tab.id == active_tab}
              className={
                tab.id == active_tab
                  ? "flex-1 rounded-lg bg-white px-4 py-2.5 text-center text-sm font-semibold text-amber-950 shadow-sm ring-1 ring-stone-900/5"
                  : "flex-1 rounded-lg px-4 py-2.5 text-center text-sm font-medium text-stone-500"
              }
            >
              <Link href={`/inertia/tabs/${tab.id}`}>{tab.label}</Link>
            </div>
          ))}
        </div>

        <main className="mt-8 space-y-6">
          <section className="grid gap-4 sm:grid-cols-3">
            {[
              { label: "Cups this week", value: "12", hint: "+3 vs last week" },
              {
                label: "Favorite origin",
                value: "Ethiopia",
                hint: "Yirgacheffe",
              },
              { label: "Avg rating", value: "4.6", hint: "out of 5" },
            ].map((stat) => (
              <div
                key={stat.label}
                className="rounded-xl border border-stone-200/80 bg-white p-5 shadow-sm"
              >
                <p className="text-xs font-medium tracking-wide text-stone-500 uppercase">
                  {stat.label}
                </p>
                <p className="mt-2 text-2xl font-semibold text-stone-900">
                  {stat.value}
                </p>
                <p className="mt-1 text-sm text-amber-800/80">{stat.hint}</p>
              </div>
            ))}
          </section>

          <section className="rounded-xl border border-stone-200/80 bg-white p-6 shadow-sm">
            <h2 className="text-lg font-semibold text-stone-900">
              Recent brews
            </h2>
            <ul className="mt-4 divide-y divide-stone-100">
              {[
                {
                  drink: "Pour-over",
                  bean: "Kenya AA — bright & berry",
                  when: "Today, 7:42 AM",
                },
                {
                  drink: "Espresso",
                  bean: "Colombia Huila — chocolate, caramel",
                  when: "Yesterday, 2:15 PM",
                },
                {
                  drink: "French press",
                  bean: "Sumatra — earthy, full body",
                  when: "Sat, 9:10 AM",
                },
              ].map((entry) => (
                <li
                  key={entry.when}
                  className="flex items-start justify-between gap-4 py-4 first:pt-0 last:pb-0"
                >
                  <div>
                    <p className="font-medium text-stone-900">{entry.drink}</p>
                    <p className="mt-0.5 text-sm text-stone-600">
                      {entry.bean}
                    </p>
                  </div>
                  <time className="shrink-0 text-sm text-stone-400">
                    {entry.when}
                  </time>
                </li>
              ))}
            </ul>
          </section>

          <section className="rounded-xl bg-linear-to-br from-amber-900 to-stone-900 p-6 text-amber-50 shadow-md">
            <h2 className="text-lg font-semibold">Tip of the day</h2>
            <p className="mt-2 text-sm leading-relaxed text-amber-100/90">
              Grind size matters: for pour-over, aim for medium-fine — about the
              texture of sea salt. A burr grinder keeps extraction even and your
              morning cup consistently sweet.
            </p>
          </section>
        </main>
      </div>
    </div>
  );
}
