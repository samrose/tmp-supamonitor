# supamonitor

A PostgreSQL extension built with [pgrx](https://github.com/pgcentralfoundation/pgrx).

## Development Setup

This project uses Nix for reproducible development environments on both aarch64-linux and aarch64-darwin.

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled

### Initialize pgrx

```bash
nix develop -c cargo pgrx init --pg17=$PG_CONFIG
```

### Build and test

```bash
nix develop -c cargo pgrx run
```
