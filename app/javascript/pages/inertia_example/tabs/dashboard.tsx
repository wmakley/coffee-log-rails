import Tabs from "@/components/Tabs";

export default function Dashboard() {
  return (
    <Tabs active_tab="dashboard">
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
        <h2 className="text-lg font-semibold text-stone-900">Recent brews</h2>
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
                <p className="mt-0.5 text-sm text-stone-600">{entry.bean}</p>
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
    </Tabs>
  );
}
