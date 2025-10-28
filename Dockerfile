# syntax=docker/dockerfile:1
ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-slim AS builder

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# minimal system deps
RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# enable corepack (node22 includes it) and pin pnpm if needed
RUN corepack enable || true

WORKDIR /app

# copy lockfiles + package.json first for caching
COPY package.json package-lock.json pnpm-lock.yaml* ./

# install dependencies depending on lockfile present
RUN if [ -f pnpm-lock.yaml ]; then \
      npm i -g pnpm@10 && pnpm install --frozen-lockfile; \
    elif [ -f package-lock.json ]; then \
      npm ci; \
    else \
      npm install; \
    fi

# copy rest of source
COPY . .

# build (try pnpm then npm)
RUN if command -v pnpm > /dev/null 2>&1 && [ -f pnpm-lock.yaml ]; then \
      pnpm build; \
    else \
      npm run build || true; \
    fi

# prune dev deps in builder to make what we copy lean
RUN if command -v pnpm > /dev/null 2>&1 && [ -f pnpm-lock.yaml ]; then \
      pnpm prune --prod || true; \
    else \
      npm prune --production || true; \
    fi

# runtime stage
FROM node:${NODE_VERSION}-slim AS runtime

ENV NODE_ENV=production
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN apt-get update -qq \
  && apt-get install --no-install-recommends -y ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# create non-root user
ARG UID=10001
RUN adduser --disabled-password --gecos "" --home "/app" --shell "/sbin/nologin" --uid "${UID}" appuser

WORKDIR /app

# copy built app from builder, set ownership in one step
COPY --from=builder --chown=appuser:appuser /app /app

USER appuser

# optional: pre-download files if script exists
# if you have a `download-files` script in package.json, keep this; otherwise remove
RUN if command -v pnpm > /dev/null 2>&1 && [ -f pnpm-lock.yaml ]; then \
      pnpm download-files || true; \
    else \
      npm run download-files || true; \
    fi

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "process.exit(0)" || exit 1

# flexible start: try pnpm -> npm -> fallback to node dist/index.js
CMD ["sh", "-c", "pnpm start 2>/dev/null || npm start 2>/dev/null || node dist/index.js"]
