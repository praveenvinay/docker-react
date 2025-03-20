# MULTI STEP BUILD - PRODUCTION FILE.  A clean image with only the production files.
FROM node:16-alpine AS builder

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

# Run tests but ensure they exit (default npm test wont exit and wait for user input)
RUN CI=true npm run test

# Build only if the tests pass.
RUN npm run build


FROM nginx:1.21-alpine

COPY --from=builder /app/build /usr/share/nginx/html

# Purely for documentation purposes.  This is not necessary.
EXPOSE 80  