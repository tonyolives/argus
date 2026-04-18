import Globe from 'react-globe.gl';

const EARTH_TEXTURE_URL =
  'https://unpkg.com/three-globe/example/img/earth-night.jpg';

export function GlobeView() {
  return (
    <section className="globe-stage" aria-label="Argus globe viewport">
      <div className="globe-frame">
        <Globe
          backgroundColor="rgba(0, 0, 0, 0)"
          globeImageUrl={EARTH_TEXTURE_URL}
          animateIn={true}
          width={820}
          height={820}
        />
      </div>
    </section>
  );
}
