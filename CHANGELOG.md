# Changelog

All notable changes to Argus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Project documentation: PRD v1.0, ADRs v1.0, System Architecture v1.0, Sprint Backlog v1.0
- Spring Boot backend scaffold with Maven wrapper, health endpoint, application profiles, and Swagger/OpenAPI support
- Frontend scaffold with React 18, TypeScript, Vite, Globe.gl, Jest, React Testing Library, ESLint, and Prettier
- Initial interactive globe UI with a dark Argus landing layout and Earth texture rendering
- Frontend API client scaffold and Vite dev proxy for backend requests during local development
- Local PostgreSQL 16 + PostGIS 3.4 Docker Compose setup with persistent data storage and verification steps
- Initial Flyway schema migration for flights, incidents, and news_articles with PostGIS-enabled geometry columns and indexes
- GitHub Actions CI workflow that runs backend and frontend tests and uploads coverage artifacts
- Shared repository contributor guidance in `AGENTS.md`
- Dev and prod Spring profile files with environment-specific polling, logging, and database settings
- Dev-only CORS configuration that allows the Vite frontend origin at `http://localhost:5173`
- Local Java 17 helper script and documented backend startup flow for profile-aware development
