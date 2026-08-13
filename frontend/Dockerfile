# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter build web --release

# ── Stage 2: Serve ────────────────────────────────────────────────────────────
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80