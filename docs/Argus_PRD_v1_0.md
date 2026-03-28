# ARGUS

**Real-Time Global OSINT Monitoring Platform**

**Product Requirements Document (PRD)**

Version 1.0 | March 2026

Classification: Internal

| | |
|---|---|
| **Document Owner** | Tony Olivares — Project Lead |
| **Status** | Draft |
| **Last Updated** | March 24, 2026 |
| **Reviewers** | N/A (Solo Project) |

---

## Table of Contents

- [1. Executive Summary](#1-executive-summary)
- [2. Problem Statement](#2-problem-statement)
- [3. Target Audience](#3-target-audience)
- [4. Product Vision](#4-product-vision)
- [5. MVP Scope Definition](#5-mvp-scope-definition)
- [6. User Stories](#6-user-stories)
- [7. Technical Architecture](#7-technical-architecture)
- [8. Data Sources](#8-data-sources)
- [9. Testing Strategy](#9-testing-strategy)
- [10. Success Metrics](#10-success-metrics)
- [11. Risks and Mitigations](#11-risks-and-mitigations)
- [12. Future Roadmap (Post-MVP)](#12-future-roadmap-post-mvp)
- [13. Glossary](#13-glossary)
- [14. Document Approval](#14-document-approval)

---

## 1. Executive Summary

Argus is a real-time global monitoring platform that visualizes live air traffic, geopolitical incidents, and world events on an interactive 3D globe. Named after the hundred-eyed giant of Greek mythology, Argus provides journalists, OSINT (Open Source Intelligence) analysts, and globally-minded individuals with a unified situational awareness dashboard.

The platform aggregates data from multiple open-source feeds — including live flight tracking, automated event detection, and global news monitoring — and presents it through an intuitive visual interface that makes complex world events immediately comprehensible.

## 2. Problem Statement

Currently, there is no free, unified platform that combines real-time flight tracking with geopolitical event monitoring in a single visual interface. Existing solutions suffer from several critical limitations:

- **Flight trackers** (FlightRadar24, FlightAware) show air traffic but provide no geopolitical context.
- **News aggregators** present text-based feeds with no spatial awareness or geographic visualization.
- **OSINT tools** (Bellingcat, Liveuamap) focus on specific conflicts and require users to manually correlate data across multiple sources.
- **Enterprise platforms** (Palantir Maven, Dataminr) provide comprehensive situational awareness but cost tens of thousands of dollars annually and are inaccessible to independent analysts.

Argus bridges this gap by providing a free, open-source OSINT dashboard that combines live air traffic, auto-detected global incidents, and relevant news — all rendered on a single interactive globe.

## 3. Target Audience

### 3.1 Primary Users

| Persona | Description | Key Needs |
|---|---|---|
| **OSINT Analysts** | Independent researchers tracking global events using publicly available data. | Real-time event detection, geographic context, source verification. |
| **Journalists** | International correspondents and newsroom staff monitoring breaking events. | Fast incident alerts, relevant source articles, visual context for reporting. |
| **Security Researchers** | Analysts at think tanks, NGOs, and academic institutions studying conflict and stability. | Historical event data, pattern recognition, exportable data. |

### 3.2 Secondary Users

- Aviation enthusiasts interested in real-time flight tracking with geopolitical overlay.
- Educators teaching international relations, geopolitics, or data visualization.
- General public seeking a visual way to understand global events beyond text-based news.

## 4. Product Vision

**Vision Statement:** *To democratize global situational awareness by providing a free, open-source platform that makes real-time world events visually accessible to everyone — from professional analysts to curious citizens.*

### 4.1 Core Principles

- **Open Data First** — Rely exclusively on free, publicly available data sources. No paywalls, no proprietary feeds.
- **Visual Clarity** — Complex world events should be immediately comprehensible through intuitive visual design.
- **Signal Over Noise** — Intelligent filtering surfaces meaningful events, not raw data dumps.
- **Performance** — The globe must remain responsive even with thousands of data points rendered simultaneously.

## 5. MVP Scope Definition

### 5.1 In Scope (MVP)

| Feature | Description | Priority | Complexity |
|---|---|---|---|
| **3D Globe** | Interactive Globe.gl visualization with dark theme, rotation, zoom, and click interactions. | P0 — Critical | Medium |
| **Live Flights** | Aircraft positions from OpenSky Network, rendered as plane icons with heading. Polling interval: 10–30 seconds. Click reveals callsign, origin country, velocity, altitude. | P0 — Critical | Medium |
| **Auto-Detected Incidents** | Global events from GDELT, filtered by severity (Goldstein Scale). Categories: Conflict, Disaster, Political, Infrastructure. Rendered as colored markers with category icons. | P0 — Critical | High |
| **Incident Detail Panel** | Click an incident to see event summary, category, severity, timestamp, and related news articles sourced from GDELT DOC API. | P1 — Important | Medium |
| **Flight Detail Panel** | Click a flight to see callsign, aircraft model (if available), origin country, altitude, velocity, heading, and vertical rate. | P1 — Important | Low |
| **News Integration** | Related news articles fetched via GDELT DOC API when an incident is selected. Displays headline, source, timestamp, and link to original article. | P1 — Important | Medium |
| **Event Filtering** | UI controls to filter incidents by category (conflict, disaster, political, infrastructure) and severity threshold. | P2 — Nice to Have | Low |

### 5.2 Explicitly Out of Scope (MVP)

- User authentication and accounts.
- AI-powered event summaries (deferred to v1.1).
- Historical playback / time-travel through past events.
- Push notifications or alerting.
- Mobile-responsive design (desktop-first for MVP).
- Real-time WebSocket streaming (polling is sufficient for MVP).
- Custom user annotations or saved views.
- Deployment to cloud infrastructure (local demo + GitHub for MVP).

## 6. User Stories

### 6.1 Globe Interaction

- As a **journalist**, I want to see a 3D globe with live data points so that I can get an immediate visual overview of global activity.
- As an **OSINT analyst**, I want to click on a flight to see its details so that I can investigate unusual air traffic patterns.
- As a **user**, I want to zoom and rotate the globe smoothly so that I can focus on specific regions of interest.

### 6.2 Incident Monitoring

- As a **journalist**, I want to see auto-detected global incidents on the globe so that I can spot breaking news events geographically.
- As an **OSINT analyst**, I want to click an incident and see related news articles so that I can verify and research the event from primary sources.
- As a **user**, I want to filter incidents by category so that I can focus on the types of events most relevant to my work.

### 6.3 Acceptance Criteria Template

Each user story in the sprint backlog must include acceptance criteria following this format:

- GIVEN [precondition], WHEN [action], THEN [expected result].
- Example: GIVEN the globe is loaded, WHEN I click on an aircraft icon, THEN a detail panel appears showing callsign, altitude, velocity, and origin country within 500ms.

## 7. Technical Architecture

### 7.1 System Overview

Argus follows a standard three-tier architecture with clear separation of concerns:

| Layer | Technology | Responsibility |
|---|---|---|
| **Frontend** | React 18 + Globe.gl | 3D globe rendering, user interactions, data visualization, state management. |
| **Backend** | Spring Boot 3 (Java 17+) | REST API, external data aggregation, polling orchestration, business logic, caching. |
| **Database** | PostgreSQL 16 + PostGIS | Persistent storage for cached flights, incidents, and news. Geospatial indexing and queries. |
| **External APIs** | OpenSky, GDELT | Live flight data (OpenSky Network API), global event detection and news (GDELT Event + DOC APIs). |

### 7.2 Tech Stack Justifications

Each technology choice is documented in a corresponding Architecture Decision Record (ADR). Key decisions:

- **Spring Boot over Node.js** — Enterprise credibility, strong typing, mature testing ecosystem (JUnit/Mockito). See [ADR-001](Argus_ADRs_v1_0.md#adr-001-spring-boot-for-backend-framework).
- **Globe.gl over Cesium.js** — Dramatically simpler API, better visual-impact-to-complexity ratio, built on Three.js. See [ADR-002](Argus_ADRs_v1_0.md#adr-002-globegl-for-3d-globe-visualization).
- **PostgreSQL + PostGIS over SQLite** — Concurrent read/write support, native geospatial queries, production-grade scalability. See [ADR-003](Argus_ADRs_v1_0.md#adr-003-postgresql-with-postgis-for-database).
- **GDELT over manual curation** — Automated, global, free, unlimited, with built-in severity scoring and geocoding. See [ADR-004](Argus_ADRs_v1_0.md#adr-004-gdelt-for-automated-incident-detection).
- **Full TDD approach** — JUnit 5 + Mockito for backend, Jest + React Testing Library for frontend. Tests written before implementation. See [ADR-005](Argus_ADRs_v1_0.md#adr-005-test-driven-development-tdd-methodology).

### 7.3 API Design

The backend exposes a RESTful API documented via OpenAPI 3.0 (Swagger). Core endpoints:

| Method | Endpoint | Description |
|---|---|---|
| **GET** | `/api/v1/flights` | Returns all currently tracked aircraft positions. |
| **GET** | `/api/v1/flights/{icao24}` | Returns detail for a specific aircraft by ICAO24 address. |
| **GET** | `/api/v1/incidents` | Returns auto-detected incidents, filterable by category and severity. |
| **GET** | `/api/v1/incidents/{id}` | Returns detail for a specific incident including metadata. |
| **GET** | `/api/v1/incidents/{id}/news` | Returns related news articles for a specific incident. |
| **GET** | `/api/v1/health` | Health check endpoint for monitoring. |

### 7.4 Data Flow

1. Scheduled pollers in Spring Boot fetch data from OpenSky (every 10–30s) and GDELT (every 15–30 min).
2. Raw data is processed through filtering/transformation services and persisted to PostgreSQL.
3. Frontend polls the Argus REST API at configurable intervals.
4. Globe.gl renders the current state; user clicks trigger detail API calls.
5. Incident detail requests trigger a secondary GDELT DOC API call for related news.

## 8. Data Sources

| Source | Data Provided | Cost | Rate Limit | Update Freq. |
|---|---|---|---|---|
| **OpenSky Network** | Live aircraft positions, velocity, callsign, ICAO24, origin country | Free | ~100 req/day (anon), 4000/day (registered) | 10–30 seconds |
| **GDELT Event API** | Geocoded global events with type, severity (Goldstein Scale), actors, date | Free, unlimited | No hard limit | 15–30 minutes |
| **GDELT DOC API** | News articles related to events/themes, with source, date, tone | Free, unlimited | No hard limit | On demand (per incident click) |

## 9. Testing Strategy

Argus follows a strict Test-Driven Development (TDD) methodology. Tests are written before implementation code for all features.

### 9.1 Testing Pyramid

| Layer | Tools | Scope | Target Coverage |
|---|---|---|---|
| **Unit Tests** | JUnit 5, Mockito | Service layer logic, data transformers, GDELT filters, DTO mapping | 90%+ on service classes |
| **Integration Tests** | Spring Boot Test, TestContainers | REST endpoints, database queries, PostGIS operations | All API endpoints |
| **Frontend Unit Tests** | Jest, React Testing Library | Component rendering, user interactions, state management | All interactive components |
| **E2E Tests (Post-MVP)** | Playwright (future) | Full user flows, globe interaction, panel workflows | Deferred to v1.1 |

### 9.2 TDD Workflow

1. Write a failing test that defines the expected behavior.
2. Write the minimum implementation code to make the test pass.
3. Refactor the code while keeping tests green.
4. Commit with a descriptive message referencing the relevant user story.

## 10. Success Metrics

MVP success is measured against the following criteria:

| Metric | Target | Measurement |
|---|---|---|
| Globe Load Time | < 3 seconds on modern hardware | Chrome DevTools Performance |
| Flight Data Freshness | < 30 seconds behind real-time | Timestamp comparison |
| Incident Detection Latency | < 30 minutes from event to globe | GDELT timestamp vs. display |
| API Response Time (p95) | < 200ms for all endpoints | Spring Actuator metrics |
| Test Coverage (Backend) | > 80% line coverage | JaCoCo report |
| Test Coverage (Frontend) | > 70% line coverage | Jest coverage report |
| Zero Critical Bugs | No P0 bugs at MVP ship date | GitHub Issues tracker |

## 11. Risks and Mitigations

| Severity | Risk | Mitigation | Owner |
|---|---|---|---|
| **High** | OpenSky rate limits exceeded during development/demo | Implement response caching with configurable TTL. Create mock data fallback for demos. Register for free account (4000 req/day). | Backend Lead |
| **High** | GDELT returns excessive noise (thousands of low-quality events) | Implement aggressive severity filters (Goldstein Scale threshold). Add category allowlist. Tune iteratively based on output quality. | Backend Lead |
| **Medium** | Globe.gl performance degrades with thousands of flight markers | Implement viewport-based rendering (only show flights in current view). Use marker clustering at low zoom levels. Profile and optimize. | Frontend Lead |
| **Medium** | Scope creep delays MVP delivery | Strict MVP scope defined in this PRD. All post-MVP features tracked in backlog with explicit deferral. Weekly scope review. | Project Lead |
| **Low** | GDELT API becomes unavailable or changes schema | Abstract data source behind interface. Implement circuit breaker pattern. Cache last-known-good data for graceful degradation. | Backend Lead |

## 12. Future Roadmap (Post-MVP)

The following features are explicitly deferred from MVP and will be evaluated for future releases:

### 12.1 v1.1 — Intelligence Layer

- AI-powered incident summaries using an LLM API (Claude or GPT) to generate concise briefings for each incident.
- Event clustering — automatically group related incidents (e.g., multiple protests in same country) into a single narrative.
- Sentiment analysis overlay showing tone of media coverage by region.

### 12.2 v1.2 — User Experience

- User accounts with saved views and custom filter presets.
- Push notifications for high-severity events via email or browser notifications.
- Mobile-responsive design for tablet and phone use.
- Historical playback — scrub through time to replay past events.

### 12.3 v2.0 — Platform

- Real-time WebSocket streaming replacing polling for sub-second updates.
- Plugin system allowing community-contributed data sources.
- API access tier for developers building on top of Argus data.
- Cloud deployment with multi-region support.

## 13. Glossary

| Term | Definition |
|---|---|
| **OSINT** | Open Source Intelligence — intelligence derived from publicly available sources. |
| **GDELT** | Global Database of Events, Language, and Tone — a free, open platform monitoring world events from news media. |
| **Goldstein Scale** | A scale from -10 to +10 measuring the theoretical impact of an event type on country stability. |
| **ICAO24** | A unique 24-bit address assigned to each aircraft transponder, used as identifier in flight tracking. |
| **PostGIS** | A spatial database extension for PostgreSQL enabling geographic object storage and queries. |
| **ADR** | Architecture Decision Record — a document capturing a significant technical decision and its rationale. |
| **TDD** | Test-Driven Development — a methodology where tests are written before implementation code. |
| **Globe.gl** | A Three.js-based library for rendering interactive 3D globes in the browser. |

## 14. Document Approval

This PRD is a living document and will be updated as requirements evolve. All changes must be tracked in the CHANGELOG and reviewed before merge.

| Role | Name | Date | Status |
|---|---|---|---|
| Project Lead | Tony Olivares | March 24, 2026 | **APPROVED** |
