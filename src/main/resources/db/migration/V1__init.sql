CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE flights (
    icao24 VARCHAR(16) PRIMARY KEY,
    callsign VARCHAR(32),
    origin_country VARCHAR(128),
    location geometry(Point, 4326) NOT NULL,
    altitude DOUBLE PRECISION,
    velocity DOUBLE PRECISION,
    heading DOUBLE PRECISION,
    vertical_rate DOUBLE PRECISION,
    on_ground BOOLEAN NOT NULL DEFAULT FALSE,
    last_seen TIMESTAMP NOT NULL
);

CREATE TABLE incidents (
    id BIGSERIAL PRIMARY KEY,
    gdelt_id BIGINT NOT NULL,
    category VARCHAR(64) NOT NULL,
    title VARCHAR(512) NOT NULL,
    goldstein_score DOUBLE PRECISION NOT NULL,
    location geometry(Point, 4326) NOT NULL,
    event_date TIMESTAMP NOT NULL,
    actors TEXT,
    source_url TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE news_articles (
    id BIGSERIAL PRIMARY KEY,
    incident_id BIGINT NOT NULL,
    title VARCHAR(512) NOT NULL,
    source VARCHAR(255) NOT NULL,
    url TEXT NOT NULL,
    published_at TIMESTAMP,
    tone DOUBLE PRECISION,
    fetched_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_news_articles_incident
        FOREIGN KEY (incident_id)
        REFERENCES incidents (id)
        ON DELETE CASCADE
);

CREATE INDEX idx_flights_location_gist
    ON flights
    USING GIST (location);

CREATE INDEX idx_incidents_location_gist
    ON incidents
    USING GIST (location);

CREATE INDEX idx_flights_last_seen
    ON flights (last_seen);

CREATE INDEX idx_incidents_category
    ON incidents (category);

CREATE INDEX idx_incidents_event_date
    ON incidents (event_date);

CREATE INDEX idx_news_articles_incident_id
    ON news_articles (incident_id);
