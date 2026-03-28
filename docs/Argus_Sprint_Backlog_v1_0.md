# ARGUS

**Real-Time Global OSINT Monitoring Platform**

**Sprint Backlog & GitHub Issues**

Version 1.0 | March 2026

7 Sprints | 36 Tickets | ~30 Days

| | |
|---|---|
| **Document Owner** | Tony Olivares — Project Lead |
| **Status** | Planning Complete |
| **Last Updated** | March 24, 2026 |
| **Methodology** | Full TDD, GitFlow |

---

## Table of Contents

- [Sprint Plan Overview](#sprint-plan-overview)
- [Sprint 1: Project Scaffolding and Infrastructure](#sprint-1-project-scaffolding-and-infrastructure)
- [Sprint 2: Backend Core — Entities, Repositories, and External API Clients](#sprint-2-backend-core--entities-repositories-and-external-api-clients)
- [Sprint 3: Backend Services — Business Logic and Polling](#sprint-3-backend-services--business-logic-and-polling)
- [Sprint 4: REST API Controllers and Integration Tests](#sprint-4-rest-api-controllers-and-integration-tests)
- [Sprint 5: Frontend — Globe Visualization and Flight Rendering](#sprint-5-frontend--globe-visualization-and-flight-rendering)
- [Sprint 6: Frontend — Incident Markers, Detail Panel, and News](#sprint-6-frontend--incident-markers-detail-panel-and-news)
- [Sprint 7: Polish, Integration Testing, and Documentation](#sprint-7-polish-integration-testing-and-documentation)
- [Appendix: Critical Path](#appendix-critical-path)

---

## Sprint Plan Overview

This document breaks the Argus MVP into 7 sprints containing 36 total tickets. Each ticket includes a unique ID, title, type, priority, labels, time estimate, dependencies, acceptance criteria, and technical notes. The tickets are ordered for sequential execution but can be parallelized where dependencies allow.

All tickets follow the TDD methodology defined in [ADR-005](Argus_ADRs_v1_0.md#adr-005-test-driven-development-tdd-methodology): write failing tests first, implement to pass, then refactor. Acceptance criteria are written in GIVEN/WHEN/THEN format wherever applicable.

### Sprint schedule

| # | Sprint | Duration | Tickets | P0s | Status |
|---|---|---|---|---|---|
| **1** | Project Scaffolding and Infrastructure | 3–4 days | 6 | **4** | Planned |
| **2** | Backend Core — Entities, Repositories, and External API Clients | 4–5 days | 6 | **4** | Planned |
| **3** | Backend Services — Business Logic and Polling | 5–6 days | 6 | **5** | Planned |
| **4** | REST API Controllers and Integration Tests | 3–4 days | 4 | **2** | Planned |
| **5** | Frontend — Globe Visualization and Flight Rendering | 4–5 days | 4 | **3** | Planned |
| **6** | Frontend — Incident Markers, Detail Panel, and News | 4–5 days | 5 | **2** | Planned |
| **7** | Polish, Integration Testing, and Documentation | 3–4 days | 5 | **1** | Planned |

### GitHub label definitions

| Label | Color | Description |
|---|---|---|
| **backend** | `#0E8A16` | Changes to Spring Boot application code |
| **frontend** | `#1D76DB` | Changes to React application code |
| **infrastructure** | `#5319E7` | Docker, CI/CD, build configuration |
| **database** | `#006B75` | Schema changes, migrations, PostGIS |
| **api** | `#FBCA04` | REST endpoint changes |
| **tdd** | `#D93F0B` | Ticket requires tests written first (TDD) |
| **visualization** | `#C2E0C6` | Globe.gl rendering and visual features |
| **ui** | `#BFD4F2` | User interface components and panels |
| **integration** | `#BFDADC` | External API integration |
| **service** | `#F9D0C4` | Backend service layer logic |
| **scheduling** | `#FEF2C0` | Scheduled polling tasks |
| **performance** | `#E4E669` | Performance optimization |
| **documentation** | `#0075CA` | Documentation and README |
| **testing** | `#D4C5F9` | Test infrastructure and E2E verification |
| **devops** | `#EDEDED` | CI/CD and deployment |
| **sprint-1** through **sprint-7** | `#FFFFFF` | Sprint assignment labels |

---

## Sprint 1: Project Scaffolding and Infrastructure

**Goal:** *Establish the monorepo structure, CI/CD pipeline, database, and dev environment so that all subsequent work has a stable foundation.*

**Duration:** 3–4 days | Tickets: 6 | P0 blockers: 4

| ID | Title | Priority | Type | Estimate |
|---|---|---|---|---|
| **ARG-001** | Initialize Spring Boot project with Maven | **P0** | Task | 2–3 hours |
| **ARG-002** | Initialize React frontend with Vite and Globe.gl | **P0** | Task | 2–3 hours |
| **ARG-003** | Docker Compose for PostgreSQL + PostGIS | **P0** | Task | 1–2 hours |
| **ARG-004** | Flyway migration setup with initial schema | **P0** | Task | 2–3 hours |
| **ARG-005** | GitHub Actions CI pipeline | **P1** | Task | 2–3 hours |
| **ARG-006** | Configure CORS and application profiles | **P1** | Task | 1 hour |

### ARG-001: Initialize Spring Boot project with Maven

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P0** |
| **Labels** | backend, infrastructure, sprint-1 |
| **Estimate** | 2–3 hours |
| **PRD Ref** | Section 7.1 — System Overview |

**Description**

Create the Spring Boot 3.2 project using Spring Initializr. Configure Java 17, add core dependencies (Spring Web, Spring Data JPA, Flyway, springdoc-openapi, Actuator), and establish the base package structure defined in the Architecture Document. Use the Maven wrapper (mvnw) for portable builds.

**Acceptance Criteria**

- GIVEN a fresh clone, WHEN I run `./mvnw spring-boot:run`, THEN the app starts on port 8080 with no errors.
- GIVEN the app is running, WHEN I hit `GET /api/v1/health`, THEN I receive a 200 response with `{ "status": "UP" }`.
- GIVEN the app is running, WHEN I hit `/swagger-ui.html`, THEN the Swagger UI loads and displays the health endpoint.
- The package structure matches the Architecture Document section 3.2.1 (controller, service, repository, model, dto, config, client packages all exist).
- `application.yml` includes profiles for dev and prod with placeholder configuration.

**Technical notes**

- Use Maven with the Spring Boot parent POM. The Maven wrapper (mvnw) should be committed to the repo for portable builds.
- Add `springdoc-openapi-starter-webmvc-ui` for Swagger auto-generation.
- Create a HealthController manually (not just Actuator) to match the `/api/v1/health` endpoint contract.
- Configure Spring Actuator to expose health, info, and metrics endpoints.

### ARG-002: Initialize React frontend with Vite and Globe.gl

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P0** |
| **Labels** | frontend, infrastructure, sprint-1 |
| **Estimate** | 2–3 hours |
| **PRD Ref** | Section 7.1 — System Overview |

**Description**

Create the React 18 project using Vite with TypeScript template. Install core dependencies (react-globe.gl, axios or fetch wrapper) and dev dependencies (Jest, React Testing Library, ESLint, Prettier). Establish the frontend directory structure.

**Acceptance Criteria**

- GIVEN a fresh clone, WHEN I run `cd frontend && npm install && npm run dev`, THEN the dev server starts on port 5173.
- GIVEN the dev server is running, WHEN I open localhost:5173, THEN I see a Globe.gl globe rendering with the default Earth texture on a dark background.
- GIVEN the project, WHEN I run `npm test`, THEN Jest runs with zero failures (even if only a placeholder test exists).
- The directory structure includes `src/components/`, `src/hooks/`, `src/services/`, `src/types/`, and `src/__tests__/`.
- ESLint and Prettier configs are present and enforced.

**Technical notes**

- Use `react-globe.gl` (React wrapper) rather than raw `globe.gl` for cleaner JSX integration.
- Set up a simple API client service (`src/services/api.ts`) with a configurable base URL pointing to localhost:8080.
- Configure proxy in `vite.config.ts` to forward `/api` requests to the backend during development.

### ARG-003: Docker Compose for PostgreSQL + PostGIS

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P0** |
| **Labels** | infrastructure, database, sprint-1 |
| **Estimate** | 1–2 hours |
| **PRD Ref** | Section 6.1 — Local Development Environment |

**Description**

Create a `docker-compose.yml` that runs PostgreSQL 16 with PostGIS 3.4. Include a `.env.example` with placeholder credentials and a `.gitignore` entry for `.env`. Verify PostGIS extension activates correctly.

**Acceptance Criteria**

- GIVEN Docker is running, WHEN I run `docker-compose up -d db`, THEN the PostgreSQL container starts and is accessible on port 5432.
- GIVEN the DB is running, WHEN I connect and run `SELECT PostGIS_Version();`, THEN it returns the PostGIS version (3.4+).
- A `.env.example` file exists with `POSTGRES_DB=argus`, `POSTGRES_USER`, and `POSTGRES_PASSWORD` placeholders.
- The `.env` file is listed in `.gitignore`.
- A `data/postgres/` directory is used for volume persistence and is gitignored.

**Technical notes**

- Use the official `postgis/postgis:16-3.4` Docker image.
- Add a healthcheck in docker-compose.yml: `pg_isready -U $POSTGRES_USER`.

### ARG-004: Flyway migration setup with initial schema

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P0** |
| **Labels** | backend, database, sprint-1 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-001, ARG-003 |
| **PRD Ref** | Architecture Doc Section 3.3 — Database |

**Description**

Configure Flyway in the Spring Boot application to manage database migrations. Create the initial migration (`V1__init.sql`) that enables PostGIS, creates the `flights`, `incidents`, and `news_articles` tables with proper column types, constraints, and spatial indexes.

**Acceptance Criteria**

- GIVEN the DB is running and I start the Spring Boot app, WHEN Flyway runs, THEN the schema is created with all three tables.
- GIVEN the schema exists, WHEN I describe the `flights` table, THEN it has columns: icao24 (PK), callsign, origin_country, location (geometry(Point,4326)), altitude, velocity, heading, vertical_rate, on_ground, last_seen.
- GIVEN the schema exists, WHEN I describe the `incidents` table, THEN it has columns: id (PK), gdelt_id, category, title, goldstein_score, location (geometry(Point,4326)), event_date, actors, source_url, created_at.
- GIVEN the schema exists, WHEN I describe the `news_articles` table, THEN it has columns: id (PK), incident_id (FK), title, source, url, published_at, tone, fetched_at.
- GiST indexes exist on `flights.location` and `incidents.location`.
- B-tree indexes exist on `flights.last_seen`, `incidents.category`, `incidents.event_date`, and `news_articles.incident_id`.

**Technical notes**

- Migration file: `src/main/resources/db/migration/V1__init.sql`.
- Enable PostGIS: `CREATE EXTENSION IF NOT EXISTS postgis;`
- Use `geometry(Point, 4326)` for location columns (WGS 84 coordinate system).
- Configure Flyway in `application.yml`: `spring.flyway.enabled=true`, `spring.flyway.locations=classpath:db/migration`.

### ARG-005: GitHub Actions CI pipeline

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P1** |
| **Labels** | infrastructure, devops, sprint-1 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-001, ARG-002, ARG-003 |
| **PRD Ref** | Architecture Doc Section 6.3 — CI/CD Pipeline |

**Description**

Create a GitHub Actions workflow (`.github/workflows/ci.yml`) that runs on every push and pull request. The workflow should build and test both backend and frontend, using a PostgreSQL service container for integration tests.

**Acceptance Criteria**

- GIVEN I push to any branch, WHEN GitHub Actions runs, THEN both backend and frontend tests execute.
- The workflow provisions a PostgreSQL + PostGIS service container for the test run.
- Backend step: `./mvnw test` completes successfully.
- Frontend step: `cd frontend && npm test -- --coverage` completes successfully.
- Coverage reports are uploaded as workflow artifacts.
- The workflow fails if any test fails.

**Technical notes**

- Use the `postgis/postgis:16-3.4` service image in the workflow.
- Set up JDK 17 with `actions/setup-java` and Node 18 with `actions/setup-node`.
- Cache Maven and npm dependencies for faster builds.

### ARG-006: Configure CORS and application profiles

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P1** |
| **Labels** | backend, infrastructure, sprint-1 |
| **Estimate** | 1 hour |
| **Depends On** | ARG-001 |
| **PRD Ref** | Architecture Doc Section 7.3 — Security |

**Description**

Configure CORS in Spring Boot to allow requests from the frontend dev server (localhost:5173). Set up dev and prod Spring profiles with appropriate defaults for polling intervals, log levels, and database connection details.

**Acceptance Criteria**

- GIVEN the backend is running with the dev profile, WHEN the frontend makes a cross-origin request from localhost:5173, THEN the request succeeds without CORS errors.
- `application-dev.yml` contains: debug-level logging, relaxed polling intervals (60s flights, 30min incidents), localhost DB connection.
- `application-prod.yml` contains: info-level logging, standard polling intervals (15s flights, 15min incidents), configurable DB URL.
- CORS configuration only allows localhost origins in dev profile.

---

## Sprint 2: Backend Core — Entities, Repositories, and External API Clients

**Goal:** *Build the data model layer and create testable client wrappers for all external APIs, fully mocked and tested before any real API calls are made.*

**Duration:** 4–5 days | Tickets: 6 | P0 blockers: 4

| ID | Title | Priority | Type | Estimate |
|---|---|---|---|---|
| **ARG-007** | Flight JPA entity and repository with PostGIS | **P0** | Feature | 3–4 hours |
| **ARG-008** | Incident JPA entity and repository with PostGIS | **P0** | Feature | 3–4 hours |
| **ARG-009** | NewsArticle JPA entity and repository | **P1** | Feature | 2–3 hours |
| **ARG-010** | OpenSky API client with mock tests | **P0** | Feature | 3–4 hours |
| **ARG-011** | GDELT Event API client with mock tests | **P0** | Feature | 3–4 hours |
| **ARG-012** | GDELT DOC API client with mock tests | **P1** | Feature | 2–3 hours |

### ARG-007: Flight JPA entity and repository with PostGIS

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, database, tdd, sprint-2 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-004 |
| **PRD Ref** | Architecture Doc Section 3.3.1 — Core Tables |

**Description**

Create the Flight JPA entity with Hibernate Spatial geometry mapping, the FlightRepository extending JpaRepository with custom spatial queries, and the FlightResponseDTO for API responses. All repository methods must have integration tests.

**Acceptance Criteria**

- Flight entity maps all columns defined in the schema (icao24 PK, callsign, origin_country, location as Point, altitude, velocity, heading, vertical_rate, on_ground, last_seen).
- FlightRepository supports: findAll (active flights), findByIcao24, upsert batch operation (INSERT ON CONFLICT DO UPDATE).
- FlightResponseDTO contains all fields needed by the frontend (icao24, callsign, originCountry, latitude, longitude, altitude, velocity, heading, verticalRate, onGround).
- Integration tests verify: save and retrieve a flight, upsert updates existing flight, spatial column stores and retrieves correctly.
- All tests pass with TestContainers PostgreSQL + PostGIS.

**Technical notes**

- Use Hibernate Spatial: `org.locationtech.jts.geom.Point` for the location column.
- Add `@Column(columnDefinition = "geometry(Point,4326)")` annotation.
- The upsert can use a `@Modifying @Query` with native SQL `INSERT ... ON CONFLICT`.
- Use TestContainers with the `postgis/postgis:16-3.4` image for integration tests.

### ARG-008: Incident JPA entity and repository with PostGIS

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, database, tdd, sprint-2 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-004 |
| **PRD Ref** | Architecture Doc Section 3.3.1 — Core Tables |

**Description**

Create the Incident JPA entity, IncidentRepository with spatial and category-based queries, and IncidentResponseDTO. Include deduplication query support.

**Acceptance Criteria**

- Incident entity maps all columns: id (generated PK), gdelt_id, category (enum: CONFLICT, DISASTER, POLITICAL, INFRASTRUCTURE), title, goldstein_score, location as Point, event_date, actors, source_url, created_at.
- IncidentRepository supports: findAll, findByCategory, findById, findNearby (ST_DWithin query for deduplication), deleteOlderThan.
- IncidentResponseDTO contains all fields needed by the frontend plus a formatted category label.
- Integration tests verify: save and retrieve, filter by category, spatial proximity query returns correct results.
- All tests pass with TestContainers.

**Technical notes**

- Category should be a Java enum mapped with `@Enumerated(EnumType.STRING)`.
- The ST_DWithin query: `SELECT * FROM incidents WHERE ST_DWithin(location, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326), :radius)`.
- Use `@Query` with `nativeQuery=true` for PostGIS-specific queries.

### ARG-009: NewsArticle JPA entity and repository

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | backend, database, tdd, sprint-2 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-004, ARG-008 |
| **PRD Ref** | Architecture Doc Section 3.3.1 — Core Tables |

**Description**

Create the NewsArticle JPA entity with a foreign key to incidents, the NewsArticleRepository, and the NewsArticleResponseDTO.

**Acceptance Criteria**

- NewsArticle entity maps: id (PK), incident_id (FK to incidents), title, source, url, published_at, tone (float), fetched_at.
- NewsArticleRepository supports: findByIncidentId, findByIncidentIdAndFetchedAtAfter (cache check), deleteByFetchedAtBefore (cache cleanup).
- NewsArticleResponseDTO: title, source, url, publishedAt, tone.
- Integration tests verify: save with incident FK, retrieve by incident ID, cache freshness check query.
- All tests pass with TestContainers.

### ARG-010: OpenSky API client with mock tests

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, integration, tdd, sprint-2 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-001 |
| **PRD Ref** | ADR-006 — OpenSky Network |

**Description**

Create the OpenSkyClient class that calls the OpenSky `/states/all` endpoint and deserializes the response into DTOs. The client must be fully unit-testable with mocked HTTP responses.

**Acceptance Criteria**

- OpenSkyClient has a method `fetchAllStates()` that returns `List<OpenSkyStateDTO>`.
- OpenSkyStateDTO maps: icao24, callsign, origin_country, longitude, latitude, baro_altitude, velocity, true_track, vertical_rate, on_ground.
- Unit tests mock the RestTemplate/WebClient response and verify: successful deserialization of a sample JSON payload, handling of empty response (no aircraft), handling of HTTP error (returns empty list, logs warning), handling of rate limit (429 response, logs warning).
- OpenSky credentials are read from `application.yml` (`opensky.username`, `opensky.password`).
- All tests pass without making real API calls.

**Technical notes**

- OpenSky returns a JSON object with a "states" array where each state is a positional array (not named keys). Custom deserialization may be needed.
- Use RestTemplate with basic auth for the HTTP call. Inject the RestTemplate so it can be mocked.
- Sample response format: `{ "time": 123, "states": [["icao24", "callsign", "origin", ...], ...] }`.

### ARG-011: GDELT Event API client with mock tests

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, integration, tdd, sprint-2 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-001 |
| **PRD Ref** | ADR-004 — GDELT for Incident Detection |

**Description**

Create the GdeltEventClient that queries the GDELT Event API v2 for recent events and deserializes into DTOs. Fully mocked and tested.

**Acceptance Criteria**

- GdeltEventClient has a method `fetchRecentEvents(int hoursBack)` returning `List<GdeltEventDTO>`.
- GdeltEventDTO maps: gdeltId, eventDate, actor1Name, actor2Name, eventCode (CAMEO), goldsteinScale, numMentions, avgTone, latitude, longitude, sourceUrl.
- Unit tests verify: successful deserialization of sample GDELT response, empty result handling, malformed response handling (partial data, missing fields), HTTP error handling.
- All tests pass without making real API calls.

**Technical notes**

- GDELT Event API v2 endpoint: `https://api.gdeltproject.org/api/v2/events/events`
- The response format can be CSV or JSON depending on query parameters. Use JSON format (`&format=json`).
- GDELT has no authentication — no API key needed.

### ARG-012: GDELT DOC API client with mock tests

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | backend, integration, tdd, sprint-2 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-001 |
| **PRD Ref** | ADR-008 — GDELT DOC API for News |

**Description**

Create the GdeltDocClient that queries the GDELT DOC API for news articles by keyword/theme. Fully mocked and tested.

**Acceptance Criteria**

- GdeltDocClient has a method `fetchArticles(String query, int maxResults)` returning `List<GdeltArticleDTO>`.
- GdeltArticleDTO maps: title, url, source, publishDate, tone, language.
- Unit tests verify: successful deserialization, empty results, HTTP error handling.
- Query construction supports keyword search with optional location and date range parameters.
- All tests pass without making real API calls.

**Technical notes**

- GDELT DOC API endpoint: `https://api.gdeltproject.org/api/v2/doc/doc?query=KEYWORD&mode=artlist&format=json`
- Max results are controlled by `&maxrecords=N` (default 25, max 250).

---

## Sprint 3: Backend Services — Business Logic and Polling

**Goal:** *Implement the core service layer: flight processing, incident filtering pipeline, news retrieval with caching, and the scheduled pollers that drive the data flow.*

**Duration:** 5–6 days | Tickets: 6 | P0 blockers: 5

| ID | Title | Priority | Type | Estimate |
|---|---|---|---|---|
| **ARG-013** | FlightService — processing and transformation logic | **P0** | Feature | 3–4 hours |
| **ARG-014** | IncidentFilterPipeline — multi-stage event filtering | **P0** | Feature | 5–6 hours |
| **ARG-015** | IncidentService — incident processing and retrieval | **P0** | Feature | 3–4 hours |
| **ARG-016** | NewsService — article retrieval with caching | **P1** | Feature | 3–4 hours |
| **ARG-017** | FlightPollerService — scheduled flight data ingestion | **P0** | Feature | 2–3 hours |
| **ARG-018** | IncidentPollerService — scheduled incident detection | **P0** | Feature | 2–3 hours |

### ARG-013: FlightService — processing and transformation logic

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, service, tdd, sprint-3 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-007, ARG-010 |
| **PRD Ref** | Architecture Doc Section 4.1 — Flight Data Flow |

**Description**

Create FlightService that transforms OpenSky DTOs into Flight entities, handles upsert logic, and manages stale flight cleanup. This is the bridge between the API client and the database.

**Acceptance Criteria**

- `FlightService.processFlightStates(List<OpenSkyStateDTO>)` transforms DTOs into Flight entities with PostGIS Point geometry and upserts them.
- `FlightService.getActiveFlights()` returns all flights with `last_seen` within the configured threshold (default 5 minutes).
- `FlightService.getFlightByIcao24(String)` returns a single flight or throws NotFoundException.
- `FlightService.cleanupStaleFlights()` removes or marks inactive any flights not seen within the threshold.
- Unit tests (Mockito) verify: DTO-to-entity mapping correctness, null/empty callsign handling, on_ground flag logic, stale cleanup logic.
- All tests use mocked FlightRepository.

### ARG-014: IncidentFilterPipeline — multi-stage event filtering

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, service, tdd, sprint-3 |
| **Estimate** | 5–6 hours |
| **Depends On** | ARG-008, ARG-011 |
| **PRD Ref** | Architecture Doc Section 3.2.3 — Incident Filter Pipeline |

**Description**

Implement the four-stage incident filter pipeline that transforms thousands of raw GDELT events into 10–30 meaningful incidents. This is the most critical piece of business logic and the primary technical talking point for interviews.

**Acceptance Criteria**

- **Stage 1 (Goldstein filter):** Events with goldsteinScale between -3.0 and +3.0 are excluded. Threshold is configurable via `application.yml` (`argus.filter.goldstein-threshold`).
- **Stage 2 (CAMEO filter):** Only events with root CAMEO codes in the allowlist pass. Default allowlist: 14x (Protest), 17x–19x (Coerce/Assault/Fight), 20x (Mass violence). Allowlist is configurable.
- **Stage 3 (Geographic dedup):** Events within 50km of each other with the same CAMEO root code are clustered. Only the highest-severity event per cluster is retained. Uses PostGIS `ST_DWithin`.
- **Stage 4 (Recency filter):** Events older than 48 hours are excluded. Threshold is configurable.
- The pipeline is implemented as a chain of filter stages, each independently testable.
- Unit tests verify each stage independently AND the full pipeline end-to-end with sample GDELT data.
- Given 500 sample events, the pipeline reduces to fewer than 50 (exact number depends on sample data distribution).

**Technical notes**

- Implement each stage as a separate class implementing a common interface (e.g., `EventFilter` with method `List<GdeltEventDTO> filter(List<GdeltEventDTO> events)`).
- The pipeline chains them: goldstein → cameo → dedup → recency.
- Geographic dedup is the trickiest stage — it requires a spatial query against existing incidents in the database.
- CAMEO codes: first two digits are the root code. 14 = Protest, 17 = Coerce, 18 = Assault, 19 = Fight, 20 = Engage in mass violence.

### ARG-015: IncidentService — incident processing and retrieval

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, service, tdd, sprint-3 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-008, ARG-014 |
| **PRD Ref** | Architecture Doc Section 4.2 — Incident Data Flow |

**Description**

Create IncidentService that processes filtered events into Incident entities, persists them, and provides retrieval methods with optional category and severity filtering.

**Acceptance Criteria**

- `IncidentService.processFilteredEvents(List<GdeltEventDTO>)` maps DTOs to Incident entities, assigns categories, and persists.
- `IncidentService.getActiveIncidents(Optional<Category>, Optional<Double>)` returns filtered incidents.
- `IncidentService.getIncidentById(Long)` returns a single incident or throws NotFoundException.
- Category mapping: CAMEO codes are mapped to IncidentCategory enum (CONFLICT, DISASTER, POLITICAL, INFRASTRUCTURE).
- Unit tests verify: DTO-to-entity mapping, category assignment logic, filtering by category and severity.

### ARG-016: NewsService — article retrieval with caching

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | backend, service, tdd, sprint-3 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-009, ARG-012, ARG-015 |
| **PRD Ref** | Architecture Doc Section 4.3 — News Article Flow |

**Description**

Create NewsService that retrieves news articles for a given incident, implements a 1-hour cache in PostgreSQL, and constructs search queries from incident metadata.

**Acceptance Criteria**

- `NewsService.getNewsForIncident(Long incidentId)` returns `List<NewsArticleResponseDTO>`.
- If cached articles exist with `fetched_at < 1 hour ago`, return cached results without calling GDELT.
- If cache is stale or empty, call GdeltDocClient with a query built from: incident title, actor names, location name.
- New articles are persisted to `news_articles` with `fetched_at = now()`.
- Unit tests verify: cache hit (no API call), cache miss (API called, results cached), empty API response handling, query construction from incident metadata.

### ARG-017: FlightPollerService — scheduled flight data ingestion

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, service, scheduling, tdd, sprint-3 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-010, ARG-013 |
| **PRD Ref** | Architecture Doc Section 3.2.2 — Scheduled Polling |

**Description**

Create the scheduled service that polls OpenSky at configurable intervals and delegates to FlightService for processing. Include error handling with exponential backoff.

**Acceptance Criteria**

- FlightPollerService runs automatically via `@Scheduled` at an interval configured by `argus.polling.flights-interval-ms` (default: 15000).
- Each poll cycle: calls `OpenSkyClient.fetchAllStates()`, passes results to `FlightService.processFlightStates()`, then calls `FlightService.cleanupStaleFlights()`.
- If OpenSkyClient throws an exception, the poller logs the error and continues (does not crash the scheduler).
- After 5 consecutive failures, polling interval doubles (exponential backoff). Resets on success.
- Unit tests verify: successful poll cycle, error handling, backoff behavior.

### ARG-018: IncidentPollerService — scheduled incident detection

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, service, scheduling, tdd, sprint-3 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-011, ARG-014, ARG-015 |
| **PRD Ref** | Architecture Doc Section 3.2.2 — Scheduled Polling |

**Description**

Create the scheduled service that polls GDELT at configurable intervals, runs the filter pipeline, and delegates to IncidentService for persistence.

**Acceptance Criteria**

- IncidentPollerService runs via `@Scheduled` at `argus.polling.incidents-interval-ms` (default: 900000 = 15 minutes).
- Each poll cycle: calls `GdeltEventClient.fetchRecentEvents(24)`, passes results through IncidentFilterPipeline, then passes survivors to `IncidentService.processFilteredEvents()`.
- Error handling and backoff mirror FlightPollerService.
- Unit tests verify: successful poll cycle end-to-end, error handling, logging of filter statistics (e.g., "Processed 1200 raw events → 23 incidents").

---

## Sprint 4: REST API Controllers and Integration Tests

**Goal:** *Expose the backend data through documented REST endpoints and verify the full request lifecycle with integration tests.*

**Duration:** 3–4 days | Tickets: 4 | P0 blockers: 2

| ID | Title | Priority | Type | Estimate |
|---|---|---|---|---|
| **ARG-019** | FlightController — flight data REST endpoints | **P0** | Feature | 2–3 hours |
| **ARG-020** | IncidentController — incident REST endpoints with filtering | **P0** | Feature | 3–4 hours |
| **ARG-021** | Global exception handler and error response format | **P1** | Feature | 1–2 hours |
| **ARG-022** | Swagger/OpenAPI documentation verification | **P1** | Task | 1 hour |

### ARG-019: FlightController — flight data REST endpoints

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, api, tdd, sprint-4 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-013 |
| **PRD Ref** | Architecture Doc Section 5 — REST API Contracts |

**Description**

Create the FlightController exposing `GET /api/v1/flights` and `GET /api/v1/flights/{icao24}`. Include proper OpenAPI annotations for Swagger documentation.

**Acceptance Criteria**

- `GET /api/v1/flights` returns 200 with a JSON array of FlightResponseDTO objects.
- `GET /api/v1/flights/{icao24}` returns 200 with a single FlightResponseDTO, or 404 if not found.
- Both endpoints include OpenAPI annotations (`@Operation`, `@ApiResponse`) for Swagger docs.
- Integration tests verify: list all flights, get by ICAO24, 404 for unknown ICAO24.
- Response time is under 200ms for 1000 cached flights (verified in integration test with seeded data).

### ARG-020: IncidentController — incident REST endpoints with filtering

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | backend, api, tdd, sprint-4 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-015, ARG-016 |
| **PRD Ref** | Architecture Doc Section 5 — REST API Contracts |

**Description**

Create the IncidentController exposing incident endpoints with category and severity filtering, plus the news sub-resource endpoint.

**Acceptance Criteria**

- `GET /api/v1/incidents` returns 200 with a JSON array of IncidentResponseDTO objects.
- `GET /api/v1/incidents?category=CONFLICT` returns only conflict incidents.
- `GET /api/v1/incidents?minSeverity=-7.0` returns only incidents with goldstein_score <= -7.0.
- `GET /api/v1/incidents/{id}` returns 200 with a single incident, or 404.
- `GET /api/v1/incidents/{id}/news` returns 200 with a JSON array of NewsArticleResponseDTO objects.
- All endpoints include OpenAPI annotations.
- Integration tests verify all endpoint behaviors including filter combinations.

### ARG-021: Global exception handler and error response format

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | backend, api, sprint-4 |
| **Estimate** | 1–2 hours |
| **Depends On** | ARG-019, ARG-020 |
| **PRD Ref** | Architecture Doc Section 7.1 — Error Handling |

**Description**

Create a `@ControllerAdvice` class that catches all exceptions and returns structured JSON error responses.

**Acceptance Criteria**

- All API errors return a consistent JSON format: `{ "error": "NOT_FOUND", "message": "Flight with ICAO24 'ABC123' not found", "timestamp": "...", "path": "/api/v1/flights/ABC123" }`.
- 404 Not Found: NotFoundException is caught and returns 404.
- 400 Bad Request: Invalid filter parameters return 400 with a descriptive message.
- 500 Internal Server Error: Unhandled exceptions return 500 with a generic message (no stack trace leak).
- Unit tests verify each error scenario.

### ARG-022: Swagger/OpenAPI documentation verification

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P1** |
| **Labels** | backend, documentation, sprint-4 |
| **Estimate** | 1 hour |
| **Depends On** | ARG-019, ARG-020, ARG-021 |
| **PRD Ref** | PRD Section 7.3 — API Design |

**Description**

Verify that the auto-generated Swagger UI at `/swagger-ui.html` correctly documents all endpoints with request parameters, response schemas, and example values. Add `@Schema` annotations to DTOs where needed.

**Acceptance Criteria**

- Swagger UI loads at `/swagger-ui.html` and displays all 6 endpoints.
- Each endpoint shows: HTTP method, path, parameters (with types), response schema, and example response.
- DTOs have `@Schema` annotations with descriptions on all fields.
- The OpenAPI JSON spec is downloadable at `/v3/api-docs`.

---

## Sprint 5: Frontend — Globe Visualization and Flight Rendering

**Goal:** *Build the core visual experience: the 3D globe with live flight markers that update in real-time via polling.*

**Duration:** 4–5 days | Tickets: 4 | P0 blockers: 3

| ID | Title | Priority | Type | Estimate |
|---|---|---|---|---|
| **ARG-023** | Globe component with dark theme and controls | **P0** | Feature | 3–4 hours |
| **ARG-024** | Flight data polling hook and API service | **P0** | Feature | 2–3 hours |
| **ARG-025** | Flight markers on the globe with heading rotation | **P0** | Feature | 4–5 hours |
| **ARG-026** | Flight detail panel on click | **P1** | Feature | 3–4 hours |

### ARG-023: Globe component with dark theme and controls

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | frontend, visualization, sprint-5 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-002 |
| **PRD Ref** | PRD Section 5.1 — 3D Globe |

**Description**

Build the main Globe React component using react-globe.gl with a dark professional theme, smooth rotation/zoom/pan controls, and atmosphere glow effect.

**Acceptance Criteria**

- GIVEN the app loads, WHEN the globe renders, THEN it displays a dark-themed Earth with visible country borders and atmosphere glow.
- GIVEN the globe is rendered, WHEN I click and drag, THEN the globe rotates smoothly.
- GIVEN the globe is rendered, WHEN I scroll, THEN the globe zooms in/out smoothly.
- The globe fills the viewport (full-screen, no scrollbars).
- Globe.gl auto-rotates slowly when not interacted with. Rotation stops on user interaction and resumes after 3 seconds of inactivity.
- Component test: Globe component renders without errors.

**Technical notes**

- Use `globeImageUrl` with a dark earth texture (night lights or dark political map).
- Set `atmosphereColor` and `atmosphereAltitude` for the glow effect.
- Use `React.useRef` for the globe instance to allow programmatic control.

### ARG-024: Flight data polling hook and API service

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | frontend, data, tdd, sprint-5 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-002, ARG-019 |
| **PRD Ref** | Architecture Doc Section 4.1 — Flight Data Flow |

**Description**

Create the `useFlights` custom hook and the API service function to poll `GET /api/v1/flights` at configurable intervals.

**Acceptance Criteria**

- `useFlights()` hook returns `{ flights, isLoading, error, lastUpdated }`.
- The hook polls `GET /api/v1/flights` every 15 seconds (configurable).
- While loading the first fetch, `isLoading` is true. After first load, subsequent polls update silently.
- If the API returns an error, the error state is set but previously fetched flights remain displayed.
- Jest tests verify: initial loading state, successful data fetch, error handling, polling interval.

**Technical notes**

- Consider using React Query (TanStack Query) for built-in polling, caching, and stale-while-revalidate behavior.
- If not using React Query, use `setInterval` with cleanup in `useEffect`.

### ARG-025: Flight markers on the globe with heading rotation

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | frontend, visualization, sprint-5 |
| **Estimate** | 4–5 hours |
| **Depends On** | ARG-023, ARG-024 |
| **PRD Ref** | PRD Section 5.1 — Live Flights |

**Description**

Render flight positions from `useFlights` as plane icons on the globe, rotated to match their heading. Markers should update smoothly when new data arrives.

**Acceptance Criteria**

- GIVEN flights data is loaded, WHEN the globe renders, THEN each active flight appears as a small plane icon at its lat/lng position.
- Plane icons are rotated to match the flight's heading (true_track).
- GIVEN new poll data arrives, WHEN positions change, THEN markers update smoothly (no flicker or jump).
- GIVEN 1000+ flights are visible, WHEN I zoom out to see the full globe, THEN rendering stays smooth (>30fps).
- GIVEN the globe is zoomed in, WHEN I hover over a plane, THEN a tooltip shows the callsign.
- Component test: flight markers render for given mock flight data.

**Technical notes**

- Use Globe.gl's `htmlElementsData` layer for custom plane icons (allows CSS rotation for heading).
- Alternative: use `pointsData` with custom SVG markers if HTML overlay is too heavy at scale.
- For performance at 1000+ markers, consider switching to `pointsData` at low zoom levels.

### ARG-026: Flight detail panel on click

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | frontend, ui, tdd, sprint-5 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-025 |
| **PRD Ref** | PRD Section 5.1 — Flight Detail Panel |

**Description**

When a user clicks a flight marker, display a side panel or popup with detailed flight information.

**Acceptance Criteria**

- GIVEN the globe is showing flights, WHEN I click a plane marker, THEN a detail panel slides in from the right side.
- The panel displays: callsign (large, bold), ICAO24 address, origin country (with flag emoji or icon), altitude (formatted with units), velocity (formatted), heading (with compass direction), vertical rate (with up/down indicator), and on-ground status.
- GIVEN a panel is open, WHEN I click a different flight, THEN the panel updates to show the new flight.
- GIVEN a panel is open, WHEN I click the close button or click empty space on the globe, THEN the panel closes.
- Component tests: panel renders with mock flight data, panel closes on close button click.

---

## Sprint 6: Frontend — Incident Markers, Detail Panel, and News

**Goal:** *Complete the second major data layer: incidents on the globe with click-through detail panels and related news articles.*

**Duration:** 4–5 days | Tickets: 5 | P0 blockers: 2

| ID | Title | Priority | Type | Estimate |
|---|---|---|---|---|
| **ARG-027** | Incident data polling hook and API service | **P0** | Feature | 2–3 hours |
| **ARG-028** | Incident markers on the globe with category styling | **P0** | Feature | 4–5 hours |
| **ARG-029** | Incident detail panel with metadata | **P1** | Feature | 3–4 hours |
| **ARG-030** | News articles list in incident detail panel | **P1** | Feature | 3–4 hours |
| **ARG-031** | Event filter bar UI | **P2** | Feature | 2–3 hours |

### ARG-027: Incident data polling hook and API service

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | frontend, data, tdd, sprint-6 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-020 |
| **PRD Ref** | Architecture Doc Section 4.2 — Incident Data Flow |

**Description**

Create the `useIncidents` custom hook to poll `GET /api/v1/incidents` at configurable intervals with optional category and severity filters.

**Acceptance Criteria**

- `useIncidents(filters?)` hook returns `{ incidents, isLoading, error, lastUpdated }`.
- The hook polls every 5 minutes (configurable). Supports category and minSeverity filter parameters.
- When filters change, the hook immediately refetches.
- Error handling mirrors useFlights (stale data preserved on error).
- Jest tests verify: initial fetch, filter application, error handling.

### ARG-028: Incident markers on the globe with category styling

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P0** |
| **Labels** | frontend, visualization, sprint-6 |
| **Estimate** | 4–5 hours |
| **Depends On** | ARG-023, ARG-027 |
| **PRD Ref** | PRD Section 5.1 — Auto-Detected Incidents |

**Description**

Render incidents as colored markers on the globe with visual styling that communicates category and severity.

**Acceptance Criteria**

- Each incident category has a distinct color: CONFLICT = red, DISASTER = orange, POLITICAL = yellow, INFRASTRUCTURE = purple.
- Marker size scales with severity (higher goldstein magnitude = larger marker).
- Incidents render as pulsing circles or ring markers (not plane icons) to visually distinguish from flights.
- GIVEN 30 incidents are active, WHEN the globe renders, THEN all incidents are visible and clickable.
- GIVEN incidents of mixed categories, WHEN I look at the globe, THEN I can visually distinguish categories by color.
- Component test: incident markers render with correct colors for given mock data.

**Technical notes**

- Use Globe.gl's `ringsData` layer for pulsing ring markers, or `htmlElementsData` for custom styled markers.
- Severity scaling: `Math.abs(goldsteinScore) / 10 * maxSize` for proportional sizing.

### ARG-029: Incident detail panel with metadata

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | frontend, ui, tdd, sprint-6 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-028 |
| **PRD Ref** | PRD Section 5.1 — Incident Detail Panel |

**Description**

When a user clicks an incident marker, display a detail panel with incident metadata and a loading state for news articles.

**Acceptance Criteria**

- GIVEN incidents are on the globe, WHEN I click an incident marker, THEN a detail panel opens showing: category (with colored badge), title/description, severity (Goldstein score with visual indicator), event date, actors involved, and source URL link.
- GIVEN the panel is open, WHEN news articles are loading, THEN a loading skeleton/spinner is shown in the news section.
- GIVEN the panel is open, WHEN I click close or click empty globe space, THEN the panel closes.
- The incident panel and flight panel share the same panel component with different content (or the same panel area, replacing content).
- Component tests: panel renders with mock incident data, loading state displays correctly.

### ARG-030: News articles list in incident detail panel

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | frontend, ui, tdd, sprint-6 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-029 |
| **PRD Ref** | PRD Section 5.1 — News Integration |

**Description**

Fetch and display related news articles when an incident is selected, using the `/api/v1/incidents/{id}/news` endpoint.

**Acceptance Criteria**

- GIVEN an incident panel is open, WHEN the news data loads, THEN up to 10 articles are displayed below the incident metadata.
- Each article shows: headline (clickable link to original), source name, publication date (relative, e.g., "2 hours ago"), and tone indicator (positive/negative/neutral).
- GIVEN the news API returns an error, WHEN the panel is open, THEN a friendly error message is shown ("Unable to load related articles") with a retry button.
- GIVEN the news API returns 0 articles, THEN a "No related articles found" message is displayed.
- Links open in a new browser tab (`target="_blank"`).
- Component tests: article list renders, empty state renders, error state renders.

### ARG-031: Event filter bar UI

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P2** |
| **Labels** | frontend, ui, tdd, sprint-6 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-027, ARG-028 |
| **PRD Ref** | PRD Section 5.1 — Event Filtering |

**Description**

Create a filter bar overlay on the globe that allows users to toggle incident categories on/off and adjust the severity threshold.

**Acceptance Criteria**

- A filter bar appears at the top or side of the globe with toggle buttons for each incident category (Conflict, Disaster, Political, Infrastructure).
- Each toggle shows the category color and can be turned on/off.
- A severity slider allows adjusting the minimum severity threshold.
- GIVEN I toggle off "Conflict", WHEN the globe updates, THEN conflict incidents are hidden.
- GIVEN I slide severity to high-only, WHEN the globe updates, THEN low-severity incidents are hidden.
- Filter state persists during the session (not across sessions for MVP).
- Component tests: filter toggles work, severity slider updates state.

---

## Sprint 7: Polish, Integration Testing, and Documentation

**Goal:** *End-to-end verification, performance tuning, error states, loading states, and final documentation for a demo-ready MVP.*

**Duration:** 3–4 days | Tickets: 5 | P0 blockers: 1

| ID | Title | Priority | Type | Estimate |
|---|---|---|---|---|
| **ARG-032** | Loading states and error boundaries | **P1** | Feature | 2–3 hours |
| **ARG-033** | Performance optimization for high marker counts | **P1** | Task | 3–4 hours |
| **ARG-034** | README with architecture diagrams and setup instructions | **P1** | Documentation | 3–4 hours |
| **ARG-035** | End-to-end smoke test with live APIs | **P0** | Task | 2–3 hours |
| **ARG-036** | Mock data generator for demos and testing | **P2** | Feature | 2–3 hours |

### ARG-032: Loading states and error boundaries

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P1** |
| **Labels** | frontend, ui, sprint-7 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-025, ARG-028 |
| **PRD Ref** | PRD Section 10 — Success Metrics |

**Description**

Add polished loading states for initial globe load, data fetching, and error scenarios.

**Acceptance Criteria**

- GIVEN the app is loading for the first time, WHEN the globe is initializing, THEN a centered loading spinner with "Loading Argus..." is displayed.
- GIVEN the backend is unreachable, WHEN the frontend fails to fetch data, THEN a non-intrusive error banner appears ("Unable to reach Argus server. Retrying...") without blocking the globe.
- A React Error Boundary wraps the app to catch rendering errors and display a fallback UI.
- GIVEN the backend recovers, WHEN the next poll succeeds, THEN the error banner auto-dismisses.

### ARG-033: Performance optimization for high marker counts

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P1** |
| **Labels** | frontend, performance, sprint-7 |
| **Estimate** | 3–4 hours |
| **Depends On** | ARG-025, ARG-028 |
| **PRD Ref** | PRD Section 11 — Risks and Mitigations |

**Description**

Profile and optimize Globe.gl rendering when thousands of flight markers are visible. Implement marker clustering or viewport-based rendering if needed.

**Acceptance Criteria**

- GIVEN 5000 flight markers are loaded, WHEN the globe renders at full zoom-out, THEN frame rate stays above 30fps.
- If marker count exceeds a threshold (configurable, default 2000), markers at low zoom levels are clustered or simplified (e.g., switch from HTML elements to WebGL points).
- Performance is measured and documented (Chrome DevTools Performance recording included in PR).

### ARG-034: README with architecture diagrams and setup instructions

| | |
|---|---|
| **Type** | Documentation |
| **Priority** | **P1** |
| **Labels** | documentation, sprint-7 |
| **Estimate** | 3–4 hours |
| **Depends On** | All previous tickets |
| **PRD Ref** | Documentation roadmap |

**Description**

Write a comprehensive README.md that serves as the project's landing page on GitHub. This is the first thing a recruiter sees.

**Acceptance Criteria**

- README includes: project name and tagline, hero screenshot or GIF of the globe in action, problem statement (2-3 sentences), tech stack with version numbers, architecture diagram (embedded SVG or image), features list (MVP), prerequisites and setup instructions (step-by-step), how to run tests, API documentation link (Swagger), project structure overview, testing methodology note, license.
- Setup instructions work on a fresh machine with only Docker, JDK 17, and Node 18 installed.
- README renders correctly on GitHub (no broken images, proper markdown).

### ARG-035: End-to-end smoke test with live APIs

| | |
|---|---|
| **Type** | Task |
| **Priority** | **P0** |
| **Labels** | testing, integration, sprint-7 |
| **Estimate** | 2–3 hours |
| **Depends On** | All feature tickets |
| **PRD Ref** | PRD Section 10 — Success Metrics |

**Description**

Manually verify the full system end-to-end with live external APIs. Document any issues and fix blockers.

**Acceptance Criteria**

- Start PostgreSQL via Docker Compose, backend via `./mvnw spring-boot:run`, frontend via `npm run dev`.
- Globe loads within 3 seconds.
- Flight markers appear within 30 seconds (first poll cycle).
- Incident markers appear within 1 minute (first GDELT poll).
- Clicking a flight opens the detail panel with correct data.
- Clicking an incident opens the detail panel with metadata.
- News articles load when an incident is selected.
- Event filters correctly show/hide incident categories.
- All backend tests pass: `./mvnw test`.
- All frontend tests pass: `npm test`.
- No console errors in browser DevTools.

### ARG-036: Mock data generator for demos and testing

| | |
|---|---|
| **Type** | Feature |
| **Priority** | **P2** |
| **Labels** | backend, testing, sprint-7 |
| **Estimate** | 2–3 hours |
| **Depends On** | ARG-007, ARG-008 |
| **PRD Ref** | ADR-006 — Consequences (mock data for demos) |

**Description**

Create a data seeder that populates the database with realistic mock flights and incidents for demos when external APIs are unavailable or rate-limited.

**Acceptance Criteria**

- A Spring profile (`demo`) seeds the database with: 200 mock flights spread across major flight routes, 15 mock incidents of varied categories and severities across different regions, 5 mock news articles per incident.
- GIVEN the app starts with `--spring.profiles.active=demo`, WHEN I open the globe, THEN I see a populated, impressive-looking demo without any external API calls.
- Mock data is realistic (flight paths over known routes, incidents in plausible locations with real-sounding descriptions).

---

## Appendix: Critical Path

The critical path through the MVP determines the minimum calendar time to completion. The longest sequential dependency chain is:

**ARG-001** (Spring Boot init) → **ARG-004** (Flyway schema) → **ARG-007/008** (Entities) → **ARG-014** (Filter pipeline) → **ARG-018** (Incident poller) → **ARG-020** (Incident API) → **ARG-028** (Incident markers) → **ARG-035** (E2E smoke test)

This chain spans all 7 sprints. The frontend work (Sprints 5-6) can be partially parallelized with late Sprint 3 and Sprint 4 backend work by using mock API responses during frontend development.

**Estimated total calendar time:** 26–33 days of focused development (assuming full-time effort).
