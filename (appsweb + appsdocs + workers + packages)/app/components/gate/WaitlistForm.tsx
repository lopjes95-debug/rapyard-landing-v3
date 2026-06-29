"use client";

import { useState } from "react";

export default function WaitlistForm() {
  const [email, setEmail] = useState("");

  async function submit() {
    await fetch("/api/waitlist", {
      method: "POST",
      body: JSON.stringify({ email }),
    });

    setEmail("");
  }

  return (
    <section className="mx-auto max-w-lg p-8">
      <input
        className="w-full rounded border border-amber-700 bg-black p-4"
        placeholder="Enter your email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <button
        onClick={submit}
        className="mt-4 w-full rounded bg-amber-500 py-4 font-bold text-black"
      >
        ENTER THE YARD
      </button>

      <p className="mt-4 text-center text-gray-400">
        Early members receive a permanent Founder badge.
      </p>
    </section>
  );
}