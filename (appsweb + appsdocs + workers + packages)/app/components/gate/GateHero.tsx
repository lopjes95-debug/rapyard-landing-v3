import Image from "next/image";

export default function GateHero() {
  return (
    <section className="relative h-screen flex items-center justify-center">
      <Image
        src="/images/gate.png"
        alt="RAPYARD"
        fill
        priority
        className="object-cover"
      />

      <div className="absolute inset-0 bg-black/50" />

      <div className="relative z-10 max-w-xl text-center px-6">
        <h1 className="text-7xl font-black tracking-widest">
          RAPYARD
        </h1>

        <p className="mt-4 text-amber-400 uppercase tracking-[.35em]">
          THE FORGE IS OPEN
        </p>

        <p className="mt-8 text-xl text-gray-300">
          Every legend starts as a spark.
        </p>
      </div>
    </section>
  );
}