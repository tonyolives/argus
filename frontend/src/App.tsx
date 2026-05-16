import { GlobeView } from './components/GlobeView';

function App() {
  return (
    <main className="app-shell">
      <section className="hero-panel">
        <p className="eyebrow">ARGUS</p>
        <h1>Real-time global OSINT monitoring.</h1>
        <p className="lede">
          Track live air traffic, geopolitical incidents, and world events on a
          single interactive globe.
        </p>
      </section>
      <GlobeView />
    </main>
  );
}

export default App;
