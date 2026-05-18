import Tabs from "@/components/Tabs";

const settings = [
  {
    label: "Display name",
    value: "William",
    action: "Edit",
  },
  {
    label: "Email",
    value: "william@example.com",
    hint: "Verified",
    hintClass: "text-emerald-700",
    action: "Edit",
  },
  {
    label: "Password",
    value: "••••••••",
    action: "Change password",
  },
];

const groups = [
  { name: "Morning Crew", since: "January 12, 2024 10:30 AM" },
  { name: "Office Espresso Club", since: "March 3, 2025 2:15 PM" },
];

export default function MyAccount() {
  return (
    <Tabs active_tab="my-account">
      <section className="rounded-xl border border-stone-200/80 bg-white p-6 shadow-sm">
        <h2 className="text-lg font-semibold text-stone-900">Settings</h2>
        <p className="mt-1 text-sm text-stone-500">
          Account details (demo only)
        </p>

        <dl className="mt-5 divide-y divide-stone-100">
          {settings.map((setting) => (
            <div
              key={setting.label}
              className="flex flex-wrap items-start justify-between gap-3 py-4 first:pt-0 last:pb-0"
            >
              <div>
                <dt className="text-xs font-medium tracking-wide text-stone-500 uppercase">
                  {setting.label}
                </dt>
                <dd className="mt-1 text-sm font-medium text-stone-900">
                  {setting.value}
                </dd>
                {setting.hint && (
                  <p className={`mt-0.5 text-sm ${setting.hintClass}`}>
                    {setting.hint}
                  </p>
                )}
              </div>
              <button
                type="button"
                disabled
                className="rounded-lg border border-stone-200 px-3 py-1.5 text-sm font-medium text-stone-600"
              >
                {setting.action}
              </button>
            </div>
          ))}
        </dl>
      </section>

      <section className="rounded-xl border border-stone-200/80 bg-white p-6 shadow-sm">
        <h2 className="text-lg font-semibold text-stone-900">
          Group memberships
        </h2>
        <p className="mt-1 text-sm text-stone-500">Groups you belong to</p>

        <div className="mt-5 overflow-hidden rounded-lg border border-stone-200">
          <table className="w-full text-left text-sm">
            <thead className="bg-stone-50 text-xs font-medium tracking-wide text-stone-500 uppercase">
              <tr>
                <th className="px-4 py-3">Group</th>
                <th className="px-4 py-3">Since</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-stone-100">
              {groups.map((group) => (
                <tr key={group.name}>
                  <td className="px-4 py-3 font-medium text-stone-900">
                    {group.name}
                  </td>
                  <td className="px-4 py-3 text-stone-600">{group.since}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </Tabs>
  );
}
