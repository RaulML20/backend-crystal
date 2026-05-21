# backend-crystal

A small REST API written in [Crystal](https://crystal-lang.org/) **without any web framework**.
Everything — the HTTP server, the router, the layered architecture, authentication and
security — is built by hand on top of Crystal's standard library, just to understand how
a backend works under the hood.

## Why

This is a personal project. Instead of reaching for a framework (like Kemal or Lucky), I
wanted to assemble the whole thing myself: route matching, middleware, the request
lifecycle, and a clean separation of concerns. It is intentionally simple but follows the
same layered structure you would find in a production backend.

## Features

- **No framework** — built directly on Crystal's `http/server`.
- **Custom Trie-based router** with support for static segments, dynamic params
  (`/users/read/:id`) and per-route authentication flags.
- **Layered architecture**: Route → Controller → Service → Repository → Entity.
- **PostgreSQL** access through the `pg` shard, with DTOs to shape input/output.
- **JWT authentication** read from a cookie, applied per route via middleware.
- **Security headers** (CSP, X-Frame-Options, etc.) and a small **CORS** handler.
- **Centralized error handling** with a custom `GenericException` and HTTP status codes.
- **Transaction helper** that maps common PostgreSQL errors to clean API responses.

## Architecture

A request flows through clearly separated layers, each with a single responsibility:

```
HTTP request
   │
   ▼
app.cr ............... server setup, global error handling, security & CORS
   │
   ▼
Router (Trie) ....... matches path, extracts params, checks auth
   │
   ▼
Route ............... wires the endpoint to a controller action
   │
   ▼
Controller .......... parses/validates the request, builds the response
   │
   ▼
Service ............. business logic
   │
   ▼
Repository .......... database queries (PostgreSQL)
   │
   ▼
Entity / DTO ........ data models and serialization
```

### Project structure

```
src/
├── app.cr                  # Entry point: server, error handling, wiring
├── config/
│   ├── cors.cr             # CORS handling
│   ├── database.cr         # PostgreSQL connection
│   ├── security.cr         # Security headers
│   └── transactions.cr     # Transaction helper + PG error mapping
├── controllers/            # Request/response handling
├── dtos/                   # Input/output data shapes + validation
├── entities/               # Database models
├── middleware/
│   └── Auth.cr             # JWT validation
├── repositories/           # Database queries
├── router/
│   ├── router.cr           # Trie-based router
│   └── trie.node.cr        # Trie node
├── routes/                 # Endpoint definitions
├── services/               # Business logic
└── utils/
    └── exception.cr        # Custom exception type
```

## API

All routes are prefixed with `/api/v1`.

> **Note:** These routes are **examples** to demonstrate the architecture — in particular how
> per-route authentication is wired through the router. The auth configuration shown here is
> intentionally minimal and would not reflect a real-world setup (e.g. `POST /add` would
> normally be a protected route).

| Method | Path                      | Auth | Description            |
|--------|---------------------------|------|------------------------|
| GET    | `/api/v1/users/readAll`   | No   | List all users         |
| GET    | `/api/v1/users/read/:id`  | Yes  | Get a user by id       |
| POST   | `/api/v1/users/add`       | No   | Create a user          |

Responses follow a simple JSON envelope:

```json
{ "ok": 1, "data": { "id": 1, "name": "Raúl", "email": "raul@example.com" } }
```

Errors return the same shape with an `error` message and the matching HTTP status code.

Protected routes expect a JWT in a `token` cookie, signed with `SECRET_KEY` (HS256).

## Requirements

- [Crystal](https://crystal-lang.org/install/) `>= 1.17.1`
- PostgreSQL

## Getting started

1. **Install dependencies**

   ```bash
   shards install
   ```

2. **Create the database table**

   ```sql
   CREATE TABLE users (
     id    SERIAL PRIMARY KEY,
     name  TEXT NOT NULL,
     email TEXT NOT NULL
   );
   ```

3. **Configure environment variables**

   Create `src/config/.env` (this file is git-ignored):

   ```env
   PORT=8080

   DB_PORT=5432
   DB_HOST=localhost
   DB_NAME=your_db
   DB_USER=postgres
   DB_PASSWORD=your_password

   SECRET_KEY=your_jwt_secret
   ```

4. **Run the server**

   ```bash
   crystal run src/app.cr
   ```

   The server will start on `http://localhost:8080` (or the `PORT` you set).

## Build

```bash
shards build --release
./bin/backend-crystal
```

## Tests

```bash
crystal spec
```

## License

[MIT](LICENSE)

## Author

- [Raúl](https://github.com/your-github-user) — creator and maintainer