# LoreShelf (Dart 서버) — NAS에서 `docker compose up -d --build`
# 1단계: Dart로 실행 파일 만들기 (SQLite 라이브러리도 같이 묶인다)
FROM dart:3.13 AS build
WORKDIR /src
COPY pubspec.yaml pubspec.lock ./
COPY server/pubspec.yaml server/
RUN dart pub get
COPY server server
RUN cd server && dart build cli -t bin/server.dart -o /out

# 2단계: 실행에 필요한 것만 담은 작은 이미지
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /out/bundle /app
COPY server/web /app/web
COPY server/migrations /app/migrations
WORKDIR /app
ENV PORT=5000 DB_PATH=/app/data/loreshelf.db ASSETS_DIR=/app/data/assets MIGRATIONS_DIR=/app/migrations WEB_DIR=/app/web TZ=Asia/Seoul
EXPOSE 5000
CMD ["/app/bin/server"]
