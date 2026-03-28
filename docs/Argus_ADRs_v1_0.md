# ARGUS

**Real-Time Global OSINT Monitoring Platform**

**Architecture Decision Records (ADRs)**

Version 1.0 | March 2026

8 Decisions Documented

| | |
|---|---|
| **Document Owner** | Tony Olivares — Project Lead |
| **Status** | Living Document |
| **Last Updated** | March 24, 2026 |
| **Format** | Michael Nygard ADR Template |

---

## Table of Contents

- [Overview](#overview)
- [ADR Index](#adr-index)
- [ADR-001: Spring Boot for Backend Framework](#adr-001-spring-boot-for-backend-framework)
- [ADR-002: Globe.gl for 3D Globe Visualization](#adr-002-globegl-for-3d-globe-visualization)
- [ADR-003: PostgreSQL with PostGIS for Database](#adr-003-postgresql-with-postgis-for-database)
- [ADR-004: GDELT for Automated Incident Detection](#adr-004-gdelt-for-automated-incident-detection)
- [ADR-005: Test-Driven Development (TDD) Methodology](#adr-005-test-driven-development-tdd-methodology)
- [ADR-006: OpenSky Network for Live Flight Data](#adr-006-opensky-network-for-live-flight-data)
- [ADR-007: Polling Over WebSockets for MVP Data Updates](#adr-007-polling-over-websockets-for-mvp-data-updates)
- [ADR-008: GDELT DOC API for News Article Retrieval](#adr-008-gdelt-doc-api-for-news-article-retrieval)

---

## Overview

Architecture Decision Records (ADRs) capture significant technical decisions made during the development of Argus. Each ADR follows a standardized template inspired by Michael Nygard's lightweight ADR format, documenting the context that prompted the decision, the options that were evaluated, the final decision and its rationale, and the consequences (both positive and negative) that follow.

ADRs are immutable once accepted. If a decision is later reversed, the original ADR is marked as "Superseded" and a new ADR is created referencing it. This preserves the decision history and makes it easy to understand why the architecture evolved.

## ADR Index

| ID | Title | Status | Date |
|---|---|---|---|
| **ADR-001** | Spring Boot for Backend Framework | **Accepted** | Mar 24, 2026 |
| **ADR-002** | Globe.gl for 3D Globe Visualization | **Accepted** | Mar 24, 2026 |
| **ADR-003** | PostgreSQL with PostGIS for Database | **Accepted** | Mar 24, 2026 |
| **ADR-004** | GDELT for Automated Incident Detection | **Accepted** | Mar 24, 2026 |
| **ADR-005** | Test-Driven Development (TDD) Methodology | **Accepted** | Mar 24, 2026 |
| **ADR-006** | OpenSky Network for Live Flight Data | **Accepted** | Mar 24, 2026 |
| **ADR-007** | Polling Over WebSockets for MVP Data Updates | **Accepted** | Mar 24, 2026 |
| **ADR-008** | GDELT DOC API for News Article Retrieval | **Accepted** | Mar 24, 2026 |

---

## ADR-001: Spring Boot for Backend Framework

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 7.2 — Tech Stack Justifications |

### Context

Argus requires a backend service that aggregates data from multiple external APIs (OpenSky, GDELT), applies business logic (filtering, transformation, caching), exposes a RESTful API to the frontend, and runs scheduled polling tasks. The backend must be well-tested, maintainable, and demonstrate production-grade engineering practices.

The primary candidates are Spring Boot (Java) and Express.js (Node.js). Both are mature, well-documented, and widely used in production. The decision should consider development velocity, testing ecosystem, resume signal, and long-term scalability.

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **Spring Boot 3 (Java 17+)** | + Strong typing catches bugs at compile time | - More verbose than Node.js for simple tasks |
| | + Mature testing ecosystem (JUnit 5, Mockito, TestContainers) | - Slower initial development for prototyping |
| | + Built-in scheduling (@Scheduled) for polling tasks | - Heavier resource footprint than Node.js |
| | + Swagger/OpenAPI auto-generation from annotations | - Requires JDK setup and build tool (Maven/Gradle) |
| | + Strong resume signal for enterprise and defense companies | |
| | + Excellent dependency injection and separation of concerns | |
| **Express.js (Node.js)** | + Faster prototyping with less boilerplate | - Dynamic typing increases runtime bug risk |
| | + Same language (JavaScript) as the React frontend | - Testing ecosystem is less structured |
| | + Lightweight and low resource footprint | - Scheduling requires third-party libraries (node-cron) |
| | + Large npm ecosystem for quick integrations | - Weaker resume signal for enterprise/defense roles |
| | | - Callback patterns can complicate error handling at scale |

### Decision

We will use **Spring Boot 3 with Java 17+** as the backend framework.

The deciding factors are: (1) the project owner is already actively building with Spring Boot, eliminating ramp-up time; (2) the testing ecosystem (JUnit 5 + Mockito + TestContainers) is best-in-class for TDD, which is a core project requirement; (3) Spring Boot's enterprise credibility is a strategic advantage for the target job market (defense, fintech, enterprise SaaS); and (4) built-in scheduling and structured dependency injection are well-suited to the polling-heavy architecture.

The additional verbosity is an acceptable tradeoff given the benefits in testability and type safety.

### Consequences

- Backend will be built with Spring Boot 3.2+, Java 17, and Gradle as the build tool.
- All external API integrations will use RestTemplate or WebClient with Mockito-based mocking in tests.
- Scheduled tasks will use Spring's `@Scheduled` annotation with configurable intervals.
- API documentation will be auto-generated via springdoc-openapi (Swagger UI).
- Developers must have JDK 17+ and Gradle installed locally.

### References

- [Spring Boot 3 Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)

---

## ADR-002: Globe.gl for 3D Globe Visualization

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 7.2 — Tech Stack Justifications |

### Context

The core visual element of Argus is an interactive 3D globe showing live flights and geopolitical incidents. The visualization library must support: rendering thousands of point markers (flights) with smooth updates, custom HTML or icon markers for categorized incidents, arc rendering for flight paths, click interactions for detail panels, smooth rotation/zoom/pan, and a dark professional aesthetic.

Three primary options were evaluated: Cesium.js (full geospatial platform), Globe.gl (Three.js-based globe), and Mapbox GL / Leaflet (2D map projections).

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **Globe.gl** | + Simple declarative API — globe with points in ~50 lines | - Not a true GIS tool — no terrain, no map tiles |
| | + Built on Three.js, excellent rendering performance | - Less mature ecosystem than Cesium or Mapbox |
| | + Native support for points, arcs, custom HTML markers, hex bins | - Custom marker styling requires HTML overlay workarounds |
| | + Stunning visual aesthetic out of the box (dark globe) | - No built-in geocoding or routing |
| | + Active maintenance, good documentation | |
| | + Low learning curve — fastest time to impressive visual output | |
| **Cesium.js** | + Full 3D geospatial platform with terrain, imagery, and 3D tiles | - Massive learning curve — weeks to configure properly |
| | + Military/defense industry standard (used by Palantir) | - Heavy bundle size (~10MB+) impacts load time |
| | + Extremely powerful for GIS applications | - Requires Cesium Ion account for imagery |
| | + Time-dynamic visualization built in | - Vastly over-engineered for MVP requirements |
| **Mapbox GL / Leaflet** | + Mature 2D mapping with rich tile layers | - 2D projection lacks the visual impact of a 3D globe |
| | + Excellent documentation and community | - Does not match the Palantir Maven aesthetic |
| | + Good performance for marker clustering | - Globe mode in Mapbox is limited and requires paid tier |
| | + Familiar to most web developers | - Less visually impressive for portfolio/demo purposes |

### Decision

We will use **Globe.gl** as the primary visualization library.

Globe.gl offers the highest ratio of visual impact to development complexity. For an MVP focused on demonstrating full-stack capability and creating a striking visual demo, Globe.gl is the clear winner. It produces the dark, professional globe aesthetic that immediately evokes Palantir Maven, while requiring a fraction of the development time that Cesium would demand.

Cesium remains a viable upgrade path for post-MVP if true GIS capabilities (terrain analysis, 3D building models, military-grade mapping) become requirements. The migration path is documented but not planned.

### Consequences

- Frontend will use `react-globe.gl` (React wrapper for Globe.gl) as the primary visualization component.
- Flight positions will be rendered as point markers with custom plane icons using the `htmlElementsData` layer.
- Incidents will be rendered as colored HTML markers with category-specific icons.
- Flight arcs (origin to destination) are deferred to post-MVP but supported natively by Globe.gl.
- True GIS features (terrain, satellite imagery, street-level detail) are not available and are explicitly out of scope for MVP.
- Three.js knowledge will be beneficial for custom visual effects but not required for core functionality.

### References

- [Globe.gl Documentation](https://globe.gl/)
- [react-globe.gl](https://github.com/vasturiano/react-globe.gl)
- [Cesium.js](https://cesium.com/platform/cesiumjs/)

---

## ADR-003: PostgreSQL with PostGIS for Database

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 7.1 — System Overview |

### Context

Argus needs persistent storage for cached flight positions, detected incidents, and fetched news articles. The database must handle concurrent writes (polling tasks inserting data) alongside concurrent reads (frontend API requests). Additionally, the data is inherently geospatial — every flight and incident has latitude/longitude coordinates, and future features will require spatial queries (e.g., "find all incidents within 500km of this point").

The project owner initially considered SQLite for simplicity. This ADR evaluates whether SQLite, PostgreSQL, or an alternative better serves the project's needs.

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **PostgreSQL 16 + PostGIS** | + Native geospatial queries via PostGIS extension | - Requires running a separate database process |
| | + Excellent concurrent read/write handling | - Slightly more setup than file-based SQLite |
| | + Production-grade — same DB used in deployment | - Heavier resource usage for a local dev machine |
| | + Rich indexing (B-tree, GiST for spatial, GIN for full-text) | |
| | + Spring Data JPA has excellent PostgreSQL support | |
| | + Free and open source with massive community | |
| | + Strong resume signal | |
| **SQLite** | + Zero configuration — single file database | - Poor concurrent write support (single-writer lock) |
| | + No separate process needed | - No native geospatial extension |
| | + Extremely lightweight | - Not suitable for production deployment |
| | + Good for simple prototypes | - Would require migration to PostgreSQL later |
| | | - Limited Spring Data JPA dialect support |
| **MongoDB** | + Flexible schema for varied event data | - Overkill for this data model which is fairly relational |
| | + Built-in geospatial queries ($geoNear, $geoWithin) | - Additional technology to learn and maintain |
| | + Good for document-oriented data like news articles | - Weaker fit with Spring Data JPA patterns |
| | | - Less resume signal for enterprise Java roles |

### Decision

We will use **PostgreSQL 16 with the PostGIS extension**.

The deciding factors are: (1) PostGIS provides native geospatial indexing and queries that directly support the core use case; (2) PostgreSQL handles concurrent reads and writes gracefully, which is critical since polling tasks write data continuously while the API serves reads; (3) using PostgreSQL from day one avoids a painful SQLite-to-Postgres migration later; and (4) PostgreSQL is the industry standard for production Java applications.

Docker will be used to run PostgreSQL locally, ensuring consistent setup across environments and simplifying the developer onboarding experience.

### Consequences

- PostgreSQL 16 will run via Docker Compose for local development.
- PostGIS extension will be enabled for geospatial column types and spatial indexing.
- Spring Data JPA with Hibernate Spatial will be used for geospatial entity mapping.
- Database schema migrations will be managed by Flyway.
- A `docker-compose.yml` will be provided in the repository for one-command database setup.
- Developers must have Docker installed locally.

### References

- [PostGIS Documentation](https://postgis.net/documentation/)
- [Hibernate Spatial](https://docs.jboss.org/hibernate/orm/current/userguide/html_single/Hibernate_User_Guide.html#spatial)
- [Flyway Migrations](https://flywaydb.org/documentation/)

---

## ADR-004: GDELT for Automated Incident Detection

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 8 — Data Sources |

### Context

A core differentiator of Argus is automated detection of global incidents (conflicts, disasters, political crises, infrastructure outages) displayed on the globe. This requires a data source that: provides global event coverage in near-real-time, includes geolocation data (lat/lng), categorizes events by type and severity, is free and does not require a commercial license, and is reliable enough for continuous polling.

The alternatives range from fully manual curation to automated feeds from conflict databases and news monitoring platforms.

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **GDELT** | + Completely free with no rate limits | - High noise ratio — requires aggressive filtering |
| | + Global coverage — monitors news in 100+ languages | - Geocoding is approximate (city/country level) |
| | + Events are geocoded (lat/lng) automatically | - Event deduplication is imperfect |
| | + Goldstein Scale provides severity scoring (-10 to +10) | - Data quality varies by region and language |
| | + CAMEO event codes provide granular categorization | - No real-time streaming — polling only |
| | + Updated every 15 minutes | |
| | + DOC API provides related news articles for free | |
| | + Academic and OSINT communities actively use it | |
| **ACLED** | + High-quality, human-curated conflict data | - Requires registration and has usage restrictions |
| | + Precise geolocation and categorization | - Focused only on conflict — misses disasters, political events |
| | + Academic gold standard for conflict research | - Delayed updates (not real-time or near-real-time) |
| | | - API access may require academic affiliation |
| **Manual Curation** | + Complete control over quality and relevance | - Does not scale — requires constant human attention |
| | + No API dependency or noise filtering needed | - Defeats the purpose of an automated monitoring platform |
| | + Can include nuanced events that automated systems miss | - Not impressive from an engineering perspective |

### Decision

We will use **GDELT** as the primary incident detection data source, with aggressive server-side filtering to manage noise.

GDELT is uniquely positioned for Argus because it combines event detection, geocoding, severity scoring, and news article retrieval in a single free platform. No other free source provides this combination. The noise problem is real but solvable through engineering — and the filtering logic itself becomes a strong technical talking point.

The filtering strategy will use a multi-layer approach: (1) Goldstein Scale threshold to exclude low-impact events, (2) CAMEO code allowlist to focus on relevant categories (armed conflict, protests, disasters, sanctions, infrastructure disruption), (3) geographic deduplication to cluster nearby events, and (4) recency filter to show only events from the last 24–48 hours.

### Consequences

- A scheduled Spring service will poll the GDELT Event API every 15–30 minutes.
- Raw events will be filtered through a configurable multi-layer pipeline before storage.
- The GDELT DOC API will be used on-demand to fetch related news articles when a user clicks an incident.
- Incident categories will map CAMEO codes to user-friendly labels: Conflict, Disaster, Political, Infrastructure.
- Filter thresholds will be configurable via application properties to allow tuning without code changes.
- A fallback set of curated seed incidents will be available for demos if GDELT is temporarily unavailable.
- ACLED remains a potential supplementary source for post-MVP if conflict-specific precision is needed.

### References

- [GDELT Project](https://www.gdeltproject.org/)
- [GDELT Event API](https://blog.gdeltproject.org/gdelt-2-0-our-global-world-in-realtime/)
- [GDELT DOC API](https://blog.gdeltproject.org/gdelt-doc-2-0-api-expanded/)
- [CAMEO Event Codes](https://eventdata.parusanalytics.com/data.dir/cameo.html)

---

## ADR-005: Test-Driven Development (TDD) Methodology

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 9 — Testing Strategy |

### Context

Argus is both a functional product and a portfolio piece intended to demonstrate production-grade engineering practices to potential employers. Testing methodology is a key differentiator — most portfolio projects have minimal or no tests. The project must balance development velocity (ship fast) with code quality (ship clean).

Three testing approaches were considered, ranging from full TDD to minimal post-hoc testing.

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **Full TDD (Red-Green-Refactor)** | + Forces clear API design before implementation | - 20–30% slower initial development velocity |
| | + Catches bugs at the earliest possible stage | - Can feel rigid when exploring unfamiliar APIs |
| | + Produces naturally testable, decoupled code | - Risk of testing trivial code (over-testing) |
| | + Test suite serves as living documentation | - Requires discipline to maintain when under time pressure |
| | + Extremely impressive in portfolio context | |
| | + Builds confidence in refactoring | |
| **Test Critical Paths Only** | + Faster development than full TDD | - Ambiguity about what qualifies as "critical" |
| | + Focuses testing effort where it matters most | - Easy to rationalize skipping tests under time pressure |
| | + Good balance of speed and quality | - Less impressive as a portfolio artifact |
| | | - Gaps in coverage may hide bugs |
| **Minimal Testing (Post-Implementation)** | + Maximum initial velocity | - Tests rarely get written retroactively |
| | + No upfront time investment in test infrastructure | - No portfolio differentiation |
| | | - Technical debt accumulates rapidly |
| | | - Refactoring becomes risky without safety net |

### Decision

We will follow **full TDD (Red-Green-Refactor)** for all backend service-layer code and all interactive frontend components.

To avoid the over-testing trap, the following are explicitly excluded from TDD requirements: Spring configuration classes, simple DTOs and entity classes with no logic, basic component rendering (e.g., a paragraph displays text), and build/deployment scripts.

The pragmatic approach: write tests first for anything that transforms, filters, processes, or makes decisions. Skip tests for anything that is purely structural or declarative.

### Consequences

- Every service class will have a corresponding test class written before the implementation.
- Backend tests will use JUnit 5 for assertions and Mockito for mocking external dependencies.
- Frontend tests will use Jest with React Testing Library, focused on user interaction flows.
- Code coverage will be tracked via JaCoCo (backend, target >80%) and Jest coverage (frontend, target >70%).
- Pull requests must include tests. PRs without tests for non-trivial code will not be merged.
- CI pipeline (GitHub Actions) will run the full test suite on every push.
- Initial velocity will be slower, but code quality and refactoring confidence will compound over time.

### References

- Kent Beck, *Test-Driven Development: By Example* (Addison-Wesley, 2002)
- [Martin Fowler on TDD](https://martinfowler.com/bliki/TestDrivenDevelopment.html)
- [JUnit 5 + Mockito Guide](https://www.baeldung.com/mockito-junit-5-extension)

---

## ADR-006: OpenSky Network for Live Flight Data

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 8 — Data Sources |

### Context

Argus requires live aircraft position data to render flights on the globe. The data must include at minimum: geographic position (lat/lng), altitude, velocity, heading, and an aircraft identifier (callsign or transponder code). The data source must be free for non-commercial use.

Several flight tracking data providers offer APIs with varying levels of access, cost, and data quality.

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **OpenSky Network** | + Completely free — no API key required for anonymous access | - Anonymous rate limit is ~100 requests/day |
| | + Returns all airborne aircraft globally in a single request | - Coverage gaps in regions with sparse ADS-B receivers |
| | + Provides position, altitude, velocity, heading, callsign, ICAO24, origin country | - No aircraft model or route information |
| | + Free registered account increases rate limit to ~4000 requests/day | - Data freshness limited to ~10 seconds at best |
| | + Open source and community-driven | |
| | + No commercial license restrictions for non-redistribution use | |
| **ADS-B Exchange** | + Comprehensive global coverage including military aircraft | - API access requires a paid subscription ($10+/month) |
| | + Real-time data with minimal delay | - Rate limits on free tier are very restrictive |
| | + Community-maintained with strong OSINT following | - Terms of service restrict commercial use |
| **FlightAware / FlightRadar24** | + Rich data including aircraft model, route, airline info | - Paid APIs — free tiers are extremely limited |
| | + Excellent coverage and data quality | - Commercial licenses required for any data display |
| | + Well-documented commercial APIs | - Expensive at scale ($100s–$1000s/month) |
| | | - Terms prohibit displaying data in competing products |

### Decision

We will use **OpenSky Network** as the sole flight data provider for MVP.

OpenSky is the only provider that is truly free and provides sufficient data for a compelling globe visualization. The limitations (no aircraft model, coverage gaps, rate limits) are acceptable for an MVP. A free registered account will be created to increase the rate limit to 4000 requests/day, which is more than sufficient for a 15–30 second polling interval.

The backend will cache flight data in PostgreSQL with a configurable TTL, reducing the number of API calls while keeping the globe reasonably current.

### Consequences

- A free OpenSky Network account will be created and credentials stored in application properties (not committed to git).
- Flight data will be polled every 15–30 seconds via the `/states/all` REST endpoint.
- Aircraft detail is limited to what OpenSky provides: ICAO24, callsign, origin country, position, altitude, velocity, heading, vertical rate, and on-ground status.
- Aircraft model, airline name, and route information are not available and are out of scope for MVP.
- A mock data generator will be created for testing and demo scenarios when API limits are reached.
- Post-MVP: enrichment from a secondary source (e.g., a static aircraft database mapping ICAO24 to aircraft type) may be added.

### References

- [OpenSky Network API](https://openskynetwork.github.io/opensky-api/)
- [OpenSky REST API States](https://openskynetwork.github.io/opensky-api/rest.html)

---

## ADR-007: Polling Over WebSockets for MVP Data Updates

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 5.2 — Explicitly Out of Scope |

### Context

Argus needs to keep the globe updated with fresh flight and incident data. Two primary patterns exist for delivering updates from server to client: HTTP polling (client requests data at intervals) and WebSocket streaming (server pushes data as it arrives). The choice impacts architecture complexity, real-time responsiveness, and development time.

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **HTTP Polling** | + Trivially simple to implement (setInterval + fetch) | - Slight delay between data availability and display |
| | + Works with standard REST endpoints — no new infrastructure | - Redundant requests when data hasn't changed |
| | + Easy to test, debug, and monitor | - Higher cumulative bandwidth for high-frequency updates |
| | + Frontend controls update frequency | |
| | + Stateless — no connection management needed | |
| | + Perfectly adequate for 10–30 second update intervals | |
| **WebSocket Streaming** | + True real-time — sub-second push from server to client | - Significant additional complexity |
| | + Efficient for high-frequency updates | - Requires Spring WebSocket configuration and STOMP protocol |
| | + Lower cumulative bandwidth for rapidly changing data | - Harder to test and debug than simple REST calls |
| | | - Overkill when source data updates every 10–30 seconds anyway |
| | | - Additional frontend state management for socket lifecycle |

### Decision

We will use **HTTP polling** for all data updates in MVP.

Since the upstream data sources themselves update every 10–30 seconds (OpenSky) and 15–30 minutes (GDELT), WebSocket streaming provides no user-visible benefit. The data simply does not change fast enough to justify the architectural complexity. Polling is simpler to build, test, and debug, and allows the MVP to ship faster.

WebSocket streaming is explicitly deferred to v2.0 as documented in the product roadmap, to be considered when (and if) sub-second updates become a real requirement.

### Consequences

- Frontend will use `setInterval` or React Query's `refetchInterval` to poll the Argus API.
- Flight data polling interval: 15–30 seconds (configurable).
- Incident data polling interval: 5–10 minutes (configurable, since GDELT updates every 15 minutes).
- No WebSocket dependencies will be added to either frontend or backend.
- The polling architecture is simple enough that it can be replaced with WebSockets later without major refactoring.

---

## ADR-008: GDELT DOC API for News Article Retrieval

| | |
|---|---|
| **Status** | **Accepted** |
| **Date** | March 24, 2026 |
| **Decision Maker** | Tony Olivares |
| **Relates To** | PRD Section 5.1 — News Integration |

### Context

When a user clicks on an incident on the Argus globe, the detail panel should display related news articles to provide context and allow the user to investigate further. This requires a news retrieval API that can search for articles by topic, location, or keywords, and return headlines, sources, timestamps, and links.

Since Argus already uses GDELT for incident detection, the question is whether to also use GDELT's DOC API for news retrieval or to integrate a separate news API.

### Options Considered

| Option | Pros | Cons |
|---|---|---|
| **GDELT DOC API** | + Already integrated — same platform as incident detection | - Article selection biased toward GDELT's crawlers |
| | + Completely free with no rate limits | - No paywall bypass — some linked articles may be behind paywalls |
| | + Returns articles with title, source, URL, date, tone, and language | - Less polished metadata than dedicated news APIs |
| | + Can search by keyword, theme, location, and time range | - Search quality varies for niche or non-English events |
| | + Keeps architecture simple (one external dependency instead of two) | |
| | + Articles are directly related to the same events GDELT detected | |
| **NewsAPI.org** | + Clean, well-documented REST API | - Free tier limited to 100 requests/day |
| | + Good coverage of major English-language sources | - Free tier is for development only — cannot be used in production |
| | + Returns thumbnails and descriptions | - Requires a separate API key and integration |
| | | - Adds a second external dependency to manage |
| **GNews API** | + Free tier with 100 requests/day | - Free tier rate limit is restrictive |
| | + Simple keyword search API | - Less granular search (no location or theme filtering) |
| | + Returns title, description, URL, source, and image | - Adds a second external dependency |
| | | - May not find relevant articles for non-headline events |

### Decision

We will use **GDELT DOC API** as the sole news retrieval source for MVP.

The architectural simplicity of using a single external platform (GDELT) for both incident detection and news retrieval is the primary driver. The DOC API is free, unlimited, and already semantically connected to the events we are displaying — meaning search results are naturally relevant without complex query construction.

The on-demand query pattern (fetch news only when a user clicks an incident) keeps API usage efficient and avoids unnecessary caching complexity.

### Consequences

- News articles will be fetched on-demand via the GDELT DOC API when a user clicks an incident.
- Search queries will be constructed from incident metadata: event description, actor names, and geographic location.
- Results will be displayed in the incident detail panel with headline, source name, publication date, and link to original article.
- Article results will be cached in PostgreSQL with a 1-hour TTL to avoid redundant API calls.
- No separate news API key or account is required.
- Post-MVP: a secondary news source (NewsAPI, GNews) may be added to improve coverage and provide fallback.

### References

- [GDELT DOC API Documentation](https://blog.gdeltproject.org/gdelt-doc-2-0-api-expanded/)
- [GDELT DOC API Query Format](https://api.gdeltproject.org/api/v2/doc/doc?query=example&mode=artlist)
