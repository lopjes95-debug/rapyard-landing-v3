import React from "react";
import ReactDOM from "react-dom/client";
import "./style.css";

function App() {
  return (
    <main className="rapyard">
      <div className="fog" />
      <section className="hero">
        <h1 className="logo">RAP<span>Y</span>ARD</h1>
        <p className="tagline">The Digital Block Where Creators Battle, Build & Rise.</p>
        <div className="cta">
          <button>ENTER THE YARD</button>
          <button>WATCH BATTLES</button>
        </div>
      </section>

      <section className="lanes">
        <h2>PICK YOUR LANE</h2>
        <div className="grid">
          <div><h3>RAPPER</h3><p>Battle. Build your fanbase. Earn your spot.</p></div>
          <div><h3>PRODUCER</h3><p>Showcase beats. Connect with artists.</p></div>
          <div><h3>LISTENER</h3><p>Vote on battles. Influence rankings.</p></div>
        </div>
      </section>

      <footer>BLEED THA BLOCK</footer>
    </main>
  );
}

ReactDOM.createRoot(document.getElementById("root")!).render(<App />);
