# AAS Ecosystem

This repository contains a Docker Compose example stack for exploring an Asset
Administration Shell (AAS) ecosystem. It brings together the AAS Suite
Community, Eclipse BaSyx repositories and registries, Keycloak, and TwinEngine
Digital Product Passport (DPP) services, with sample assets and plugins.

## Repository contents

The runnable example is in [`examples/aas-ecosystem`](examples/aas-ecosystem):

- `docker-compose.yml` defines the application and supporting services.
- `.env.example` and `.env.example-arm` provide starting configurations for
  x86-64 and ARM64 systems.
- `infrastructure-bootstrap/`, `keycloak-bootstrap/`, and `postgres-init/`
  initialize the databases and local identity-provider configuration.
- `stack-assets/` contains sample AAS XML, media, and Keycloak theme assets.
- `plugins/` contains example AAS Suite plugins and their bundling script.
- `dpp-security/` and `stack-assets/security_env/` contain example DPP and
  environment security configuration.

## Run the example stack

You need Docker Engine and the Docker Compose plugin. The stack downloads its
service images when it starts.

1. Select the environment file for your machine:

   ```bash
   cd examples/aas-ecosystem
   cp .env.example .env
   ```

   For an ARM64 machine, use `cp .env.example-arm .env` instead.
2. Review `.env` and set a hostname that resolves to the Docker host. For a
   local-only setup, the default is `aas-ecosystem.local`; add it to your
   machine's hosts file or local DNS if it does not already resolve. Change
   the example credentials and secrets before exposing the stack to any
   network.
3. Start the services:

   ```bash
   docker compose up -d
   ```
4. Open the URL configured by `BASE_URL` in `.env` (the default is
   `http://aas-ecosystem.local`). The initial organization administrator
   credentials are controlled by `INITIAL_ORGANISATION_ADMIN_EMAIL` and
   `INITIAL_ORGANISATION_ADMIN_PASSWORD` in `.env`.

Check startup progress with `docker compose ps` and
`docker compose logs -f`. Stop the services with `docker compose down`.

## Sample AAS assets

The `aas-seed-import` service converts XML files in
`stack-assets/aas-import/raw-xml/` to JSON and imports them into the BaSyx
repositories when the stack starts. To rerun the import after adding or
changing XML seed files:

```bash
docker compose up -d aas-seed-import
docker compose logs --since 2m aas-seed-import
```

See [`stack-assets/aas-import/README.md`](examples/aas-ecosystem/stack-assets/aas-import/README.md)
for details.

## Plugins

The plugin directory includes documentation and examples for AAS Suite GUI
plugins. See [`plugins/README.md`](examples/aas-ecosystem/plugins/README.md)
for the plugin format, bundling instructions, and the included TwinEngine UI
plugin.

## Notes

This is a demonstration and development stack, not a production deployment
configuration. Review the supplied environment values, credentials, security
policies, and exposed ports before using it outside a trusted local
environment.
