import {
  GateHero,
  FeatureGrid,
  CreatorBenefits,
  WaitlistForm,
  FounderCounter,
  Footer,
} from "@/components/gate";

export default function HomePage() {
  return (
    <main className="min-h-screen bg-black text-white">
      <GateHero />

      <FeatureGrid />

      <CreatorBenefits />

      <WaitlistForm />

      <FounderCounter />

      <Footer />
    </main>
  );
}