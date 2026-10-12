# Base stage with Node.js and npm
FROM node:24-alpine AS base
RUN apk add --no-cache git
WORKDIR /app

# install all dependencies
FROM base AS deps
COPY package.json package-lock.json ./
# Git hooks are set up on the host, so skip Husky during the image build.
RUN HUSKY=0 npm ci

# for hot reload development (runtime image for dev)
FROM base AS development

ARG LOCAL_UID=1000
ARG LOCAL_GID=1000
ARG UNAME=devuser
ARG UGROUP=__PROJECT_SLUG__

RUN set -eux; \
  if ! getent group ${LOCAL_GID}; then \
    addgroup -g ${LOCAL_GID} "${UGROUP}"; \
  else \
    # gid already exists, use the existing group name
    EXISTING_GROUP=$(awk -F':' '$3 == "'${LOCAL_GID}'" {print $1}' /etc/group); \
    echo "Group '${UGROUP}' already exists with gid '${LOCAL_GID}': '${EXISTING_GROUP}'"; \
    group="${EXISTING_GROUP}"; \
  fi; \
  # Reuse an existing user when the host UID matches one in the Node image.
  if ! getent passwd "${LOCAL_UID}"; then \
    TARGET_GROUP=$(getent group "${LOCAL_GID}" | cut -d: -f1); \
    adduser -D -u "${LOCAL_UID}" -G "${TARGET_GROUP}" -h "/home/${UNAME}" "${UNAME}"; \
  fi;

USER ${LOCAL_UID}:${LOCAL_GID}

COPY --from=deps --chown=${LOCAL_UID}:${LOCAL_GID} /app/node_modules ./node_modules
COPY --chown=${LOCAL_UID}:${LOCAL_GID} . /app

EXPOSE 3000
CMD ["npm", "run", "dev"]

# build the application
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Make the asset copy work even when the starter has no public files.
RUN mkdir -p public && npm run build

# minimal runtime image for production
FROM node:24-alpine AS production
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
# Listen on all container interfaces so Docker can forward requests.
ENV HOSTNAME=0.0.0.0

# Copy standalone build
COPY --from=builder --chown=node:node /app/.next/standalone ./
COPY --from=builder --chown=node:node /app/.next/static ./.next/static
# We don't currently store any assets in a public folder right now
COPY --from=builder --chown=node:node /app/public ./public

USER node

EXPOSE 3000
CMD ["node", "server.js"]
