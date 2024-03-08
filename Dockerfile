# Build stage
FROM golang:1.20.2 AS builder

WORKDIR /app

COPY . .
RUN go mod tidy -v && CGO_ENABLED=0 go build -v -o /app/example-beego


# Run stage
FROM scratch AS runner

WORKDIR /app

COPY --from=builder /app/example-beego .
COPY --from=builder /app/conf ./conf
COPY --from=builder /app/views ./views
COPY --from=builder /app/static ./static

ARG PORT
EXPOSE "${PORT:-8000}"
CMD ["/app/example-beego"]
