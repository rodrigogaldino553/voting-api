# Rails 8 API - Election Management System

This is a modern Rails 8 API designed for managing elections and candidates, featuring secure JWT-based authentication.

## Features

- **Rails 8 API-only** architecture.
- **JWT Authentication** using Devise and `devise-jwt` with `JTIMatcher` revocation strategy.
- **Dockerized Environment** for development, testing, and sidekiq.
- **PostgreSQL** database.
- **Redis** for caching and background jobs.
- **Comprehensive Spec Suite** with RSpec and 99%+ code coverage.

---

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

### Local Development Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd api
   ```

2. **Setup environment variables**:
   Ensure `.env` exists in the root (referenced by docker-compose).

3. **Build and start the services**:
   ```bash
   docker compose up --build
   ```

4. **Prepare the database**:
   ```bash
   docker compose run --rm web rails db:prepare
   ```

The API will be available at `http://localhost:3000`.

---

## API Documentation

### Authentication Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/signup` | Register a new user |
| `POST` | `/login` | Sign in and receive a JWT token in the `Authorization` header |
| `DELETE` | `/logout` | Revoke the JWT token and sign out |

### Elections API (`/api/v1/elections`)

*Requires Authentication Header: `Authorization: Bearer <token>`*

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/elections` | List all elections |
| `POST` | `/api/v1/elections` | Create a new election |
| `GET` | `/api/v1/elections/:id` | Show specific election details |
| `PATCH/PUT` | `/api/v1/elections/:id` | Update an existing election |
| `DELETE` | `/api/v1/elections/:id` | Delete an election |

### Candidates API (`/api/v1/candidates`)

*Requires Authentication Header: `Authorization: Bearer <token>`*

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/v1/candidates` | List all candidates |
| `POST` | `/api/v1/candidates` | Create a new candidate |
| `GET` | `/api/v1/candidates/:id` | Show specific candidate details |
| `PATCH/PUT` | `/api/v1/candidates/:id` | Update an existing candidate |
| `DELETE` | `/api/v1/candidates/:id` | Delete a candidate |

---

## Domain Entities

### User
Handles authentication.
- **Attributes**: `email`, `password`, `jti` (unique identifier for JWT revocation).
- **Strategy**: Uses `JTIMatcher` to invalidate tokens on logout.

### Election
Represents a voting event.
- **Attributes**: `name` (unique, titleized), `expiration_at`.
- **Associations**: `has_many :candidates`.
- **Logic**: Automatically sets `expiration_at` to one year from creation if not provided.

### Candidate
Represents a participant in an election.
- **Attributes**: `name` (titleized), `election_id`.
- **Associations**: `belongs_to :election`.

---

## Testing

The project uses **RSpec** for testing. To execute the full suite:

```bash
docker compose run --rm rspec bundle exec rspec
```

To view code coverage, check the `coverage/` directory after running the specs (not tracked in Git).

---

## Background Processing

Background jobs are handled by **Sidekiq** and backed by **Redis**. Access the Sidekiq monitor (locally) via the configuration if enabled, or monitor the `sidekiq` container logs:

```bash
docker compose logs -f sidekiq
```
