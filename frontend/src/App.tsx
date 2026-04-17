import { GlobeView } from './components/GlobeView';

function App() {
  return (
    <main className="app-shell">
      <section className="hero-panel">
        <p className="eyebrow">ARGUS</p>
        <h1>Real-time global OSINT monitoring.</h1>
        <p className="lede">
          Sprint 1 scaffolds the frontend shell, tooling, and project structure
          for the live globe experience.
        </p>
      </section>
      <GlobeView />
    </main>
  );
}

export default App;
