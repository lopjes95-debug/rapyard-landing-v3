const features = [
  "🎙 Recording Booth",
  "🎧 Beat Discovery",
  "🥊 Battle Arena",
  "📰 The Yard",
  "👤 Profile",
  "🎛 Studio Pro Lite",
];

export default function FeatureGrid() {
  return (
    <section className="mx-auto grid max-w-6xl gap-6 p-10 md:grid-cols-3">
      {features.map((feature) => (
        <div
          key={feature}
          className="rounded-xl border border-amber-700 bg-zinc-900 p-6 text-center"
        >
          <h3 className="font-semibold">{feature}</h3>
        </div>
      ))}
    </section>
  );
}