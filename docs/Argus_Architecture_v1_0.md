# ARGUS

**Real-Time Global OSINT Monitoring Platform**

**System Architecture Document**

Version 1.0 | March 2026

| | |
|---|---|
| **Document Owner** | Tony Olivares — Project Lead |
| **Status** | Draft |
| **Last Updated** | March 24, 2026 |
| **Related Docs** | PRD v1.0, ADRs v1.0 |

---

## Table of Contents

- [1. Architecture Overview](#1-architecture-overview)
- [2. System Topology](#2-system-topology)
- [3. Component Architecture](#3-component-architecture)
- [4. Data Flow Patterns](#4-data-flow-patterns)
- [5. REST API Contracts](#5-rest-api-contracts)
- [6. Infrastructure and DevOps](#6-infrastructure-and-devops)
- [7. Cross-Cutting Concerns](#7-cross-cutting-concerns)
- [8. Future Architecture Considerations](#8-future-architecture-considerations)
- [9. Diagram Reference](#9-diagram-reference)

---

## 1. Architecture Overview

Argus uses a three-tier architecture with a React single-page application (SPA) as the presentation layer, a Spring Boot REST API as the application layer, and PostgreSQL with PostGIS as the data layer. The system aggregates data from external APIs through scheduled polling, processes and caches it server-side, and serves it to the frontend via a documented REST API.

This document describes the system topology, component responsibilities, data flow patterns, database schema, API contracts, and infrastructure configuration. It should be read alongside the [PRD](Argus_PRD_v1_0.md) (product requirements) and [ADRs](Argus_ADRs_v1_0.md) (technical decisions).

## 2. System Topology

The following table summarizes all runtime components and their responsibilities:

| Component | Technology | Responsibility | Port / Access |
|---|---|---|---|
| **Frontend SPA** | React 18, Globe.gl, Vite | 3D globe rendering, user interactions, state management, polling orchestration | localhost:5173 (Vite dev) |
| **Backend API** | Spring Boot 3.2, Java 17, Maven | REST API, scheduled polling, data aggregation, business logic, caching | localhost:8080 |
| **Database** | PostgreSQL 16, PostGIS 3.4 | Persistent storage, geospatial indexing, full-text search | localhost:5432 |
| **OpenSky API** | External REST API | Live aircraft position data (ICAO24, callsign, lat/lng, altitude, velocity) | opensky-network.org |
| **GDELT Event API** | External REST API | Auto-detected global events with geocoding and severity scoring | api.gdeltproject.org |
| **GDELT DOC API** | External REST API | News article retrieval by keyword, theme, location | api.gdeltproject.org |

## 3. Component Architecture

### 3.1 Frontend (React + Globe.gl)

The frontend is a React 18 single-page application built with Vite. The primary visual component is a Globe.gl instance rendered via the `react-globe.gl` wrapper. The frontend is responsible for:

- Rendering the interactive 3D globe with flight markers and incident indicators.
- Polling the Argus REST API at configurable intervals for updated data.
- Managing UI state: selected flight/incident, active filters, panel visibility.
- Rendering detail panels when a user clicks a flight or incident marker.
- Fetching related news articles on demand when an incident is selected.

**Key libraries:** `react-globe.gl` (globe rendering), React Query or SWR (data fetching and cache), React Testing Library + Jest (testing).

**Directory structure (planned):**

```
frontend/src/
├── components/    # Globe, FlightPanel, IncidentPanel, FilterBar
├── hooks/         # useFlights, useIncidents, useNews
├── services/      # API client functions
├── types/         # TypeScript interfaces for API response models
└── __tests__/     # Jest + RTL test files
```

### 3.2 Backend (Spring Boot 3)

The backend is a Spring Boot 3.2 application running on Java 17. It serves three purposes: aggregating data from external APIs via scheduled polling, applying business logic (filtering, transformation, caching), and exposing a RESTful API for the frontend.

#### 3.2.1 Package structure

| Package | Responsibility |
|---|---|
| `com.argus.controller` | REST controllers exposing `/api/v1/*` endpoints. Thin layer — delegates to services. |
| `com.argus.service` | Core business logic: FlightService, IncidentService, NewsService. All TDD-tested. |
| `com.argus.service.poller` | Scheduled tasks: FlightPollerService, IncidentPollerService. `@Scheduled` with configurable intervals. |
| `com.argus.service.filter` | IncidentFilterPipeline: multi-stage filtering (Goldstein threshold, CAMEO allowlist, dedup, recency). |
| `com.argus.repository` | Spring Data JPA repositories with custom PostGIS queries. |
| `com.argus.model` | JPA entities: Flight, Incident, NewsArticle. Hibernate Spatial for geometry columns. |
| `com.argus.dto` | Data Transfer Objects for API responses. Decoupled from entities. |
| `com.argus.config` | Spring configuration: RestTemplate beans, CORS, scheduling, Swagger/OpenAPI. |
| `com.argus.client` | External API clients: OpenSkyClient, GdeltEventClient, GdeltDocClient. Mockable for tests. |

#### 3.2.2 Scheduled polling architecture

Two independent pollers run as Spring `@Scheduled` tasks:

| Poller | Interval | Source | Behavior |
|---|---|---|---|
| **FlightPollerService** | 15-30 seconds | OpenSky `/states/all` | Fetches all airborne aircraft globally. Upserts into flights table by ICAO24 address. Stale flights (not seen in 5 min) are marked inactive. |
| **IncidentPollerService** | 15-30 minutes | GDELT Event API v2 | Fetches events from last 24h. Pipes through IncidentFilterPipeline. Inserts new incidents, deduplicates against existing by location + type + time window. |

#### 3.2.3 Incident filter pipeline

The IncidentFilterPipeline is the most critical piece of business logic. It transforms thousands of raw GDELT events into 10-30 meaningful incidents displayed on the globe. The pipeline consists of four stages executed in order:

1. **Goldstein Scale filter** — Removes events with severity between -3 and +3 (low-impact, routine diplomatic activity). Threshold is configurable via `application.yml`.

2. **CAMEO code allowlist** — Only passes events matching specific CAMEO root codes: 14x (Protest), 17x-19x (Armed conflict/assault), 20x (Unconventional mass violence), plus natural disaster and infrastructure codes.

3. **Geographic deduplication** — Clusters events within a configurable radius (default: 50km). Only the highest-severity event per cluster is retained. Uses PostGIS `ST_DWithin` for spatial proximity.

4. **Recency filter** — Excludes events older than 48 hours (configurable). Prevents stale incidents from cluttering the globe.

### 3.3 Database (PostgreSQL + PostGIS)

PostgreSQL 16 runs in a Docker container with the PostGIS 3.4 extension enabled. Schema migrations are managed by Flyway and versioned in the repository under `src/main/resources/db/migration/`.

#### 3.3.1 Core tables

| Table | Key Columns | Index | Notes |
|---|---|---|---|
| **flights** | icao24 (PK), callsign, origin_country, latitude, longitude, altitude, velocity, heading, vertical_rate, on_ground, last_seen | GiST on location (geometry), B-tree on last_seen | Upserted by ICAO24 on each poll. Stale rows pruned. |
| **incidents** | id (PK), gdelt_id, category, title, goldstein_score, location (geometry), event_date, actors, source_url, created_at | GiST on location, B-tree on category + event_date | Deduplicated by location + type + time window. |
| **news_articles** | id (PK), incident_id (FK), title, source, url, published_at, tone, fetched_at | B-tree on incident_id + fetched_at | Cached with 1-hour TTL. Fetched on demand. |

#### 3.3.2 PostGIS usage

The `location` column in both `flights` and `incidents` uses the PostGIS `geometry(Point, 4326)` type, which stores WGS 84 coordinates (standard GPS). Key spatial queries:

- `ST_DWithin(a.location, b.location, radius)` — Used in deduplication to cluster nearby incidents.
- `ST_MakeEnvelope(lon1, lat1, lon2, lat2, 4326)` — Bounding box queries for viewport-based filtering (post-MVP).
- `ST_Distance(a.location, b.location)` — Used for sorting incidents by proximity to a clicked point.

## 4. Data Flow Patterns

### 4.1 Flight data flow

1. `FlightPollerService` fires every 15-30 seconds via `@Scheduled`.
2. `OpenSkyClient` calls `GET https://opensky-network.org/api/states/all` with basic auth.
3. Response (JSON array of aircraft state vectors) is deserialized into `FlightStateDTO` objects.
4. `FlightService` maps DTOs to `Flight` entities, computing PostGIS `Point` geometry from lat/lng.
5. `FlightRepository.upsertBatch()` performs an `INSERT ... ON CONFLICT (icao24) DO UPDATE`.
6. Stale flights (`last_seen > 5 minutes ago`) are marked `on_ground = true` or deleted by a cleanup task.
7. Frontend polls `GET /api/v1/flights` every 15-30 seconds. `FlightController` returns all active flights as `FlightResponseDTO`.
8. Globe.gl renders each flight as a positioned plane icon with heading rotation.

### 4.2 Incident data flow

1. `IncidentPollerService` fires every 15-30 minutes via `@Scheduled`.
2. `GdeltEventClient` calls the GDELT Event API v2 for events in the last 24 hours.
3. Raw events (potentially thousands) are passed to `IncidentFilterPipeline`.
4. Pipeline applies four filter stages: Goldstein threshold, CAMEO allowlist, geographic dedup, recency filter.
5. Surviving events (typically 10-30) are mapped to `Incident` entities and persisted.
6. Frontend polls `GET /api/v1/incidents` every 5-10 minutes. `IncidentController` returns active incidents as `IncidentResponseDTO`.
7. Globe.gl renders each incident as a colored marker with category-specific styling.

### 4.3 News article flow (on demand)

1. User clicks an incident marker on the globe. Frontend sends `GET /api/v1/incidents/{id}/news`.
2. `IncidentController` delegates to `NewsService`.
3. `NewsService` checks the `news_articles` cache. If cached articles exist and `fetched_at < 1 hour ago`, return cached.
4. Otherwise, `GdeltDocClient` queries the GDELT DOC API with keywords derived from the incident (event description, actor names, location).
5. Returned articles are mapped to `NewsArticle` entities, persisted to cache, and returned as `NewsArticleResponseDTO`.
6. Frontend renders the articles in the incident detail panel with headline, source, date, and link.

## 5. REST API Contracts

All endpoints are prefixed with `/api/v1`. Detailed request/response schemas are documented via springdoc-openapi and available at `/swagger-ui.html` when the backend is running.

| Method | Endpoint | Response | Notes |
|---|---|---|---|
| **GET** | `/api/v1/flights` | `FlightResponseDTO[]` — array of active aircraft | Polled by frontend every 15-30s |
| **GET** | `/api/v1/flights/{icao24}` | `FlightResponseDTO` — single aircraft detail | Triggered by click on flight marker |
| **GET** | `/api/v1/incidents` | `IncidentResponseDTO[]` — filtered incidents | Supports `?category=` and `?minSeverity=` params |
| **GET** | `/api/v1/incidents/{id}` | `IncidentResponseDTO` — single incident detail | Triggered by click on incident marker |
| **GET** | `/api/v1/incidents/{id}/news` | `NewsArticleResponseDTO[]` — related articles | On-demand GDELT DOC fetch with cache |
| **GET** | `/api/v1/health` | `{ status, uptime, dataSources }` | Includes external API connectivity check |

## 6. Infrastructure and DevOps

### 6.1 Local development environment

The entire stack runs locally using Docker Compose for the database and standard tooling for the application:

| Component | How to Run | Prerequisites |
|---|---|---|
| PostgreSQL + PostGIS | `docker-compose up -d db` | Docker Desktop installed |
| Spring Boot backend | `./mvnw spring-boot:run` | JDK 17, Maven 3.9+ |
| React frontend | `cd frontend && npm run dev` | Node 18+, npm 9+ |
| Full test suite | `./mvnw test && cd frontend && npm test` | All of the above |

### 6.2 Docker Compose configuration

A `docker-compose.yml` in the project root provides the PostgreSQL + PostGIS container. Key configuration:

- **Image:** `postgis/postgis:16-3.4` (official PostGIS image based on PostgreSQL 16).
- **Port mapping:** `5432:5432` for local access.
- **Volume:** `./data/postgres:/var/lib/postgresql/data` for persistence across restarts.
- **Environment:** `POSTGRES_DB=argus`, `POSTGRES_USER` and `POSTGRES_PASSWORD` from `.env` file (not committed).

### 6.3 CI/CD pipeline (GitHub Actions)

A GitHub Actions workflow runs on every push and pull request:

1. Checkout code.
2. Set up JDK 17 and Node 18.
3. Start PostgreSQL + PostGIS service container.
4. Run backend tests: `./mvnw test` (JUnit 5, Mockito, TestContainers).
5. Run frontend tests: `npm test -- --coverage` (Jest, React Testing Library).
6. Generate coverage reports: JaCoCo (backend), Jest coverage (frontend).
7. Upload coverage artifacts.

### 6.4 Environment variables and secrets

Sensitive values are stored in a `.env` file (gitignored) and referenced in `application.yml`. A `.env.example` is committed with placeholder values:

- `OPENSKY_USERNAME` / `OPENSKY_PASSWORD` — Free OpenSky Network account credentials.
- `POSTGRES_USER` / `POSTGRES_PASSWORD` — Database credentials.
- `SPRING_PROFILES_ACTIVE` — `dev` (local) or `prod` (deployed). Controls logging level and polling intervals.

Profile behavior:
- `application.yml` contains shared defaults and disables DB-dependent autoconfiguration when no profile is set.
- `application-dev.yml` enables the local PostgreSQL connection, Flyway, debug logging, relaxed poll intervals, and CORS for `http://localhost:5173`.
- `application-prod.yml` enables env-driven database settings, production poll intervals, and info-level logging.

## 7. Cross-Cutting Concerns

### 7.1 Error handling and resilience

- **Circuit breaker pattern:** If an external API (OpenSky, GDELT) returns 5 consecutive errors, the poller backs off exponentially (30s, 60s, 120s, 240s) before retrying. The globe continues displaying cached data during outages.
- **Graceful degradation:** If OpenSky is unreachable, flights display with last-known positions (marked as stale). If GDELT is unreachable, incidents continue showing cached events.
- **Global exception handler:** A `@ControllerAdvice` class catches all exceptions and returns structured error responses (JSON with error code, message, timestamp).

### 7.2 Logging and observability

- SLF4J + Logback for structured logging. Log levels configurable per package via `application.yml`.
- Spring Actuator enabled for health checks, metrics, and info endpoints.
- Key metrics: API response time (p50, p95, p99), external API call count and error rate, polling cycle duration, active flight and incident counts.

### 7.3 Security (MVP scope)

- No authentication for MVP — the application runs locally and is not exposed to the internet.
- In the `dev` profile, CORS is configured to allow `http://localhost:5173` and reject unconfigured origins.
- The `prod` profile does not enable the dev-only localhost CORS rule.
- OpenSky credentials stored in `.env` file, never committed to version control.
- Post-MVP: Spring Security with JWT authentication will be added when user accounts are implemented.

### 7.4 Performance considerations

- **Flight data caching:** The backend caches the latest flight positions in-memory (with PostgreSQL as the source of truth). API responses are served from cache to keep p95 < 200ms.
- **Globe rendering:** Globe.gl is configured with a maximum marker count. At low zoom levels, markers are clustered to prevent rendering thousands of individual plane icons.
- **Database indexing:** GiST indexes on geometry columns ensure spatial queries (deduplication, bounding box) complete in < 10ms.
- **Lazy news loading:** News articles are only fetched when a user clicks an incident, avoiding unnecessary API calls and database writes.

## 8. Future Architecture Considerations

The following architectural changes are anticipated for post-MVP releases. The current architecture is designed to accommodate these without major refactoring:

- **WebSocket streaming (v2.0):** Replace polling with a Spring WebSocket/STOMP layer. The service layer and database remain unchanged; only the controller and frontend data-fetching layers need modification.
- **AI summarization (v1.1):** Add an LLM API call (Claude or GPT) to the NewsService to generate incident briefings. The summary is cached alongside news articles.
- **Event sourcing (v2.0):** Store all raw events from GDELT before filtering, enabling historical playback and re-processing with different filter parameters.
- **Microservices extraction (v2.0+):** If scaling demands it, the flight poller, incident poller, and API server can be split into separate services communicating via a message queue (RabbitMQ or Kafka). The current package structure is already aligned with this boundary.

## 9. Diagram Reference

Two architecture diagrams accompany this document:

**Diagram 1: High-Level System Architecture**

Shows the three-tier topology: external data sources (OpenSky, GDELT Event API, GDELT DOC API) at the top, the Spring Boot backend container with internal components (pollers, service layer, REST controllers) in the middle, and PostgreSQL + React frontend at the bottom. Arrows indicate data flow direction and protocol (polling intervals, REST + JSON, read/write).

**Diagram 2: Data Flow Architecture**

Shows the two primary data pipelines side by side: the flight data pipeline (left: OpenSky → poller → service → PostGIS) and the incident data pipeline (right: GDELT → poller → filter pipeline → PostGIS). Below the divider, the on-demand user request flow shows how the React frontend queries both controllers and how the NewsService fetches articles from the GDELT DOC API.

Both diagrams are also available as interactive SVG versions in the project README.
