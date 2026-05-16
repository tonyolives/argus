# Contributing to Argus

## Branching Strategy (GitFlow)

| Branch | Purpose |
|---|---|
| `main` | Production-ready releases. Tagged with semver (e.g., `v1.0.0`). |
| `develop` | Integration branch. All feature work merges here first. |
| `feature/ARG-XXX-short-desc` | Individual ticket work. Branched from `develop`. |
| `hotfix/short-desc` | Emergency fixes. Branched from `main`, merged to both `main` and `develop`. |

### Workflow

```
1. git checkout develop && git pull
2. git checkout -b feature/ARG-XXX-short-description
3. source ./scripts/use-java17.sh && export SPRING_PROFILES_ACTIVE=dev
4. Write tests → implement → refactor (TDD)
5. git commit using conventional commits (see below)
6. git push -u origin feature/ARG-XXX-short-description
7. Open PR targeting develop
8. CI must pass before merge
```

For local backend work, keep this startup flow handy:

```bash
source ./scripts/use-java17.sh
export SPRING_PROFILES_ACTIVE=dev
docker compose up -d db
./mvnw spring-boot:run
```

## Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/). Every commit message follows this format:

```
<type>(scope): <description>

[optional body]

[optional footer — e.g., Closes #12]
```

### Types

| Type | When to use |
|---|---|
| `feat` | New feature or user-facing behavior |
| `fix` | Bug fix |
| `test` | Adding or updating tests (no production code change) |
| `refactor` | Code restructuring with no behavior change |
| `docs` | Documentation only |
| `chore` | Build, CI, tooling, dependency updates |
| `style` | Formatting, whitespace (no logic change) |
| `perf` | Performance improvement |

### Examples

```
feat(ARG-014): implement Goldstein scale filter stage
test(ARG-014): add unit tests for CAMEO code allowlist
fix(ARG-017): handle null callsign in OpenSky response
docs: update README with setup instructions
chore: add JaCoCo coverage plugin to Maven build
```

## Test-Driven Development (TDD)

All non-trivial code follows the Red-Green-Refactor cycle:

1. **Red** — Write a failing test that defines the expected behavior.
2. **Green** — Write the minimum code to make the test pass.
3. **Refactor** — Clean up while keeping tests green.

### What requires TDD

- Service layer classes
- Filter/pipeline logic
- API client wrappers
- REST controllers (integration tests)
- Interactive frontend components
- Custom hooks

### What is exempt from TDD

- Spring configuration classes
- Simple DTOs / entities with no logic
- Static component rendering (e.g., a label displays text)
- Build and deployment scripts

### Coverage Targets

| Layer | Target | Tool |
|---|---|---|
| Backend | >80% line coverage | JaCoCo |
| Frontend | >70% line coverage | Jest |

## Pull Request Guidelines

- Reference the ticket ID in the PR title: `feat(ARG-014): Implement incident filter pipeline`
- Fill out the PR template completely
- Ensure CI passes before requesting review
- Include tests — PRs without tests for non-trivial code will not be merged
- Update CHANGELOG.md for user-facing changes

## Code Style

- **Java:** Follow standard Java conventions. 4-space indentation.
- **TypeScript/React:** Follow ESLint + Prettier configuration. 2-space indentation.
- **SQL:** Uppercase keywords, lowercase identifiers, snake_case for column names.

The `.editorconfig` file enforces basic formatting across all IDEs.
