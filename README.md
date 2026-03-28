# 🛰️ Argus

**Real-Time Global OSINT Monitoring Platform**

Argus visualizes live air traffic, geopolitical incidents, and world events on an interactive 3D globe. Named after the hundred-eyed giant of Greek mythology, Argus gives journalists, OSINT analysts, and security researchers a unified situational awareness dashboard — powered entirely by free, open-source data.

<!-- TODO: Replace with hero screenshot or GIF after Sprint 5 -->
<!-- ![Argus Globe](docs/images/argus-hero.png) -->

> 🚧 **Status: Actively under development** — see the [Changelog](CHANGELOG.md) for progress.

---

## The Problem

There is no free, unified platform that combines real-time flight tracking with geopolitical event monitoring in a single visual interface. Flight trackers lack geopolitical context. News aggregators lack spatial awareness. Enterprise platforms like Palantir Maven provide comprehensive situational awareness but cost tens of thousands of dollars annually. Argus bridges this gap.

## Features (MVP)

- **Interactive 3D Globe** — Dark-themed Globe.gl visualization with smooth rotation, zoom, and click interactions
- **Live Flight Tracking** — Real-time aircraft positions from OpenSky Network, rendered as heading-rotated plane icons
- **Auto-Detected Incidents** — Global events from GDELT, filtered through a multi-stage pipeline (Goldstein Scale, CAMEO codes, geographic deduplication, recency)
- **Incident Detail Panels** — Click any incident for metadata, severity scoring, and related news articles
- **News Integration** — On-demand article retrieval via GDELT DOC API with server-side caching
- **Event Filtering** — Filter incidents by category (Conflict, Disaster, Political, Infrastructure) and severity

## Tech Stack

| Layer | Technology | Version |
|---|---|---|
| **Frontend** | React, TypeScript, Globe.gl, Vite | 18.x, 5.x |
| **Backend** | Spring Boot, Java | 3.2.x, 17 |
| **Database** | PostgreSQL, PostGIS | 16, 3.4 |
| **Testing** | JUnit 5, Mockito, Jest, React Testing Library | — |
| **CI/CD** | GitHub Actions | — |
| **Infrastructure** | Docker Compose | — |

## Architecture

Argus uses a three-tier architecture: a React SPA for the presentation layer, a Spring Boot REST API for the application layer, and PostgreSQL with PostGIS for the data layer. Scheduled pollers aggregate data from external APIs (OpenSky, GDELT), process it through filtering and transformation services, and serve it via documented REST endpoints.

<!-- TODO: Embed architecture diagram SVG after Sprint 7 -->
<!-- ![Architecture](docs/diagrams/architecture.svg) -->

For full details, see the [System Architecture Document](docs/Argus_Architecture_v1_0.md) and [Architecture Decision Records](docs/Argus_ADRs_v1_0.md).

## Getting Started

### Prerequisites

- **Docker Desktop** (for PostgreSQL + PostGIS)
- **JDK 17+** ([Eclipse Temurin](https://adoptium.net/) recommended)
- **Node.js 18+** and npm 9+

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/tony-olivares/argus.git
cd argus

# 2. Configure environment
cp .env.example .env
# Edit .env with your OpenSky credentials and database password

# 3. Start the database
docker-compose up -d db

# 4. Start the backend
./mvnw spring-boot:run

# 5. Start the frontend (in a new terminal)
cd frontend
npm install
npm run dev
```

Open [http://localhost:5173](http://localhost:5173) to see the globe.

API documentation is available at [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) when the backend is running.

### Running Tests

```bash
# Backend (JUnit 5 + Mockito + TestContainers)
./mvnw test

# Frontend (Jest + React Testing Library)
cd frontend && npm test

# Frontend with coverage
cd frontend && npm test -- --coverage
```

## Project Structure

```
argus/
├── .github/                    # Issue templates, PR template, CI workflows
├── frontend/                   # React + TypeScript SPA
│   ├── src/
│   │   ├── components/         # Globe, FlightPanel, IncidentPanel, FilterBar
│   │   ├── hooks/              # useFlights, useIncidents, useNews
│   │   ├── services/           # API client functions
│   │   ├── types/              # TypeScript interfaces
│   │   └── __tests__/          # Jest + RTL tests
│   └── ...
├── src/main/java/com/argus/    # Spring Boot backend
│   ├── controller/             # REST controllers (/api/v1/*)
│   ├── service/                # Core business logic (FlightService, IncidentService)
│   ├── service/poller/         # Scheduled polling tasks
│   ├── service/filter/         # Incident filter pipeline
│   ├── repository/             # Spring Data JPA + PostGIS queries
│   ├── model/                  # JPA entities
│   ├── dto/                    # API response objects
│   ├── client/                 # External API clients (OpenSky, GDELT)
│   └── config/                 # Spring configuration
├── src/main/resources/
│   └── db/migration/           # Flyway SQL migrations
├── docs/                       # Architecture docs, ADRs, diagrams
├── docker-compose.yml
├── CHANGELOG.md
├── CONTRIBUTING.md
└── LICENSE
```

## Testing Methodology

Argus follows strict **Test-Driven Development (TDD)** — tests are written before implementation for all service-layer code and interactive frontend components. See [ADR-005](docs/Argus_ADRs_v1_0.md) for the full rationale and [CONTRIBUTING.md](CONTRIBUTING.md) for the TDD workflow.

| Layer | Tool | Target Coverage |
|---|---|---|
| Backend unit tests | JUnit 5 + Mockito | >80% |
| Backend integration tests | Spring Boot Test + TestContainers | All API endpoints |
| Frontend tests | Jest + React Testing Library | >70% |

## Documentation

| Document | Description |
|---|---|
| [Product Requirements (PRD)](docs/Argus_PRD_v1_0.md) | Scope, user stories, success metrics |
| [Architecture Decision Records](docs/Argus_ADRs_v1_0.md) | 8 technical decisions with rationale |
| [System Architecture](docs/Argus_Architecture_v1_0.md) | Component design, data flows, API contracts |
| [Sprint Backlog](docs/Argus_Sprint_Backlog_v1_0.md) | 36 tickets across 7 sprints |
| [API Reference](http://localhost:8080/swagger-ui.html) | Auto-generated OpenAPI docs (run backend first) |

## Data Sources

| Source | Purpose | Cost |
|---|---|---|
| [OpenSky Network](https://opensky-network.org/) | Live aircraft positions | Free |
| [GDELT Event API](https://www.gdeltproject.org/) | Auto-detected global events | Free |
| [GDELT DOC API](https://blog.gdeltproject.org/gdelt-doc-2-0-api-expanded/) | Related news articles | Free |

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## Author

**Tony Olivares** — Project Lead

---

*Named after Argus Panoptes, the hundred-eyed giant of Greek mythology who served as an ever-vigilant watchman.*
