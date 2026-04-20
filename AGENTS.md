# AGENTS.md

This file provides guidance to coding agents and contributors working in this repository.

## Project Overview

Argus is a real-time global OSINT monitoring platform that visualizes live air traffic,
geopolitical incidents, and world events on an interactive 3D globe.

Current status:
- Sprint 0 documentation is complete
- Sprint 1 establishes the backend, frontend, database, and local dev foundations

## Core Commands

### Infrastructure
```bash
docker-compose up -d db
docker-compose ps
docker-compose exec db psql -U argus_user -d argus -c "SELECT PostGIS_Version();"
docker-compose down
```

### Backend
```bash
./mvnw spring-boot:run
SPRING_PROFILES_ACTIVE=dev ./mvnw spring-boot:run
./mvnw test
./mvnw clean package
./mvnw spotless:check
./mvnw spotless:apply
./mvnw clean test jacoco:report
```

### Frontend
```bash
cd frontend
npm install
npm run dev
npm test
npm run lint
npm run format
```

## Local Development

Run the project in three terminals:
1. `docker-compose up -d db`
2. `./mvnw spring-boot:run`
3. `cd frontend && npm install && npm run dev`

Database verification for ARG-003:
1. `cp .env.example .env`
2. `docker-compose up -d db`
3. `docker-compose ps`
4. `docker-compose exec db psql -U argus_user -d argus -c "SELECT PostGIS_Version();"`

Schema verification for ARG-004:
1. `cp .env.example .env`
2. `docker-compose up -d db`
3. `SPRING_PROFILES_ACTIVE=dev ./mvnw spring-boot:run`
4. `./scripts/verify_arg004_schema.sh`

Important local URLs:
- Frontend: `http://localhost:5173`
- Backend API: `http://localhost:8080`
- Swagger UI: `http://localhost:8080/swagger-ui.html`

## Architecture

Argus uses a three-tier architecture:
- Frontend: React 18 SPA with `react-globe.gl`
- Backend: Spring Boot 3 REST API with scheduled polling
- Database: PostgreSQL 16 + PostGIS 3.4

### Backend package structure
```text
src/main/java/com/argus/
├── controller/
├── service/
├── service/poller/
├── service/filter/
├── repository/
├── model/
├── dto/
├── client/
└── config/
```

### Frontend structure
```text
frontend/src/
├── components/
├── hooks/
├── services/
├── types/
└── __tests__/
```

## Data Sources

- OpenSky Network API: live aircraft positions
- GDELT Event API: incident detection
- GDELT DOC API: related news article retrieval

## Environment Variables

Copy `.env.example` to `.env` before starting local services.

Expected values include:
```bash
POSTGRES_DB=argus
POSTGRES_USER=argus_user
POSTGRES_PASSWORD=changeme
OPENSKY_USERNAME=...
OPENSKY_PASSWORD=...
SPRING_PROFILES_ACTIVE=dev
```

## Development Conventions

### TDD

TDD is mandatory for:
- backend service classes
- filter/pipeline logic
- REST controllers
- interactive frontend components
- custom hooks

TDD is not required for:
- Spring configuration
- simple DTOs and entities
- static or purely presentational components
- build and deployment scripts

Use Red-Green-Refactor:
1. Write the failing test first
2. Implement the minimum code to pass
3. Refactor with tests still green

### Branching

GitFlow conventions:
- `main` for production releases
- `develop` for integration
- `feature/ARG-XXX-description` for sprint ticket work
- `hotfix/description` for emergency fixes

### Commit Format

Use Conventional Commits:
```text
<type>(scope): <description>
```

Common types:
- `feat`
- `fix`
- `test`
- `refactor`
- `docs`
- `chore`
- `style`
- `perf`

### Code Style

- Java: 4-space indentation
- TypeScript/React: 2-space indentation
- SQL: uppercase keywords, `snake_case` identifiers

### Testing Targets

- Backend coverage: `>80%`
- Frontend coverage: `>70%`

## Ticket Guidance

Before closing a sprint ticket:
- verify the exact acceptance criteria in `docs/Argus_Sprint_Backlog_v1_0.md`
- verify related architecture constraints in `docs/Argus_Architecture_v1_0.md`
- ensure tests and manual verification match the ticket scope

## Notes

- Keep repo guidance here project-specific and shared.
- Do not store secrets, local-only paths, or personal workflow notes in this file.
