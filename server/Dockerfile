# An example of using a custom Dockerfile with Dart Frog
# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build



WORKDIR /app

# Copy shared package
COPY shared/pubspec.* shared/
COPY shared/lib shared/lib

# Copy server package
COPY server/pubspec.* server/
COPY server/main.dart server/
COPY server/lib server/lib
COPY server/routes server/routes
COPY server/public server/public
COPY server/analysis_options.yaml server/
COPY server/build.yaml server/

# Resolve dependencies
WORKDIR /app/server
RUN dart pub get

# Generate a production build with Dart Frog
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Copy shared package to build directory for compilation
RUN cp -r /app/shared /app/server/build/../

# Ensure packages are still up-to-date if anything has changed.
WORKDIR /app/server/build
# Remove pubspec_overrides.yaml if it exists to avoid workspace issues
RUN rm -f pubspec_overrides.yaml
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
#FROM scratch


FROM alpine:latest
# Install SQLite3 binary and shared library for runtime
RUN apk add --no-cache sqlite sqlite-libs

# Create symlink for libsqlite3.so (Alpine uses libsqlite3.so.0)
RUN ln -s /usr/lib/libsqlite3.so.0 /usr/lib/libsqlite3.so

COPY --from=build /runtime/ /
COPY --from=build /app/server/build/bin/server /app/bin/
# Copy public directory for serving static files
COPY --from=build /app/server/public/ /public/


# Create /data directory for volume mount
RUN mkdir -p /data
# Allow user to mount local server/data to /data in container
# Example: docker run -d -p 8088:8088 -v $(pwd)/data:/data --name smartopia-hms smartopia-hms

EXPOSE 8080

# Start the server.
CMD ["/app/bin/server"]