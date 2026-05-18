import Tabs from "@/components/Tabs";

const entries = [
  {
    coffee: "Kenya AA — Nyeri",
    method: "Pour-over",
    ratio: "18 / 300",
    brewRatio: "1 : 16.7",
    details: "Grind 22; 93°C",
    rating: "★★★★☆",
    preparation: "Bloom 45s, then slow spiral pour.",
    tasting: "Bright berry, black tea finish.",
    date: "May 17, 2026 7:42 AM",
  },
  {
    coffee: "Colombia Huila — Decaf",
    method: "Espresso",
    ratio: "18 / 36",
    brewRatio: "1 : 2",
    details: "Grind 14; 25s pull",
    rating: "★★★★★",
    preparation: null,
    tasting: "Chocolate, caramel, clean finish.",
    date: "May 16, 2026 2:15 PM",
  },
  {
    coffee: "Sumatra Mandheling",
    method: "French press",
    ratio: "30 / 450",
    brewRatio: "1 : 15",
    details: "Grind 28; 4 min steep",
    rating: "★★★☆☆",
    preparation: "Stir once after 1 minute.",
    tasting: "Earthy, full body, low acidity.",
    date: "May 15, 2026 9:10 AM",
  },
];

export default function LogEntries() {
  return (
    <Tabs active_tab="log-entries">
      <section className="rounded-xl border border-stone-200/80 bg-white p-6 shadow-sm">
        <h2 className="text-lg font-semibold text-stone-900">New entry</h2>
        <p className="mt-1 text-sm text-stone-500">
          William&apos;s Log — quick-add form (demo only)
        </p>

        <div className="mt-5 grid gap-4 sm:grid-cols-2">
          <label className="block">
            <span className="text-xs font-medium tracking-wide text-stone-500 uppercase">
              Coffee
            </span>
            <input
              type="text"
              readOnly
              value="Ethiopia Yirgacheffe — washed"
              className="mt-1 w-full rounded-lg border border-stone-200 bg-stone-50 px-3 py-2 text-sm text-stone-700"
            />
          </label>
          <label className="block">
            <span className="text-xs font-medium tracking-wide text-stone-500 uppercase">
              Brew method
            </span>
            <select
              disabled
              className="mt-1 w-full rounded-lg border border-stone-200 bg-stone-50 px-3 py-2 text-sm text-stone-700"
            >
              <option>Pour-over</option>
            </select>
          </label>
          <label className="block">
            <span className="text-xs font-medium tracking-wide text-stone-500 uppercase">
              Coffee (g)
            </span>
            <input
              type="text"
              readOnly
              value="18"
              className="mt-1 w-full rounded-lg border border-stone-200 bg-stone-50 px-3 py-2 text-sm text-stone-700"
            />
          </label>
          <label className="block">
            <span className="text-xs font-medium tracking-wide text-stone-500 uppercase">
              Water (g)
            </span>
            <input
              type="text"
              readOnly
              value="300"
              className="mt-1 w-full rounded-lg border border-stone-200 bg-stone-50 px-3 py-2 text-sm text-stone-700"
            />
          </label>
        </div>

        <button
          type="button"
          disabled
          className="mt-5 rounded-lg bg-amber-800/40 px-4 py-2 text-sm font-semibold text-white"
        >
          Log brew
        </button>
      </section>

      <section className="rounded-xl border border-stone-200/80 bg-white p-6 shadow-sm">
        <h2 className="text-lg font-semibold text-stone-900">
          William&apos;s Log
        </h2>
        <p className="mt-1 text-sm text-stone-500">3 entries</p>

        <ul className="mt-4 divide-y divide-stone-100">
          {entries.map((entry) => (
            <li key={entry.date} className="py-4 first:pt-0 last:pb-0">
              <div className="flex items-start justify-between gap-4">
                <div className="min-w-0 flex-1">
                  <p className="font-medium text-stone-900">
                    {entry.coffee}{" "}
                    <span className="font-normal text-stone-500">
                      ({entry.method} — {entry.ratio} — {entry.brewRatio})
                    </span>
                  </p>
                  <p className="mt-0.5 text-sm text-stone-500">
                    {[entry.details, entry.rating].join("; ")}
                  </p>
                  {entry.preparation && (
                    <p className="mt-1 text-sm text-stone-600">
                      {entry.preparation}
                    </p>
                  )}
                  {entry.tasting && (
                    <p className="mt-0.5 text-sm text-stone-600">
                      {entry.tasting}
                    </p>
                  )}
                </div>
                <time className="shrink-0 text-right text-sm text-stone-400">
                  {entry.date}
                </time>
              </div>
            </li>
          ))}
        </ul>
      </section>
    </Tabs>
  );
}
