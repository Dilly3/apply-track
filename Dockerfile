
# Build the Go executable.
FROM golang:1.27-alpine AS builder

WORKDIR /src

# Download dependencies separately so Docker can cache this step.
COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 go build -trimpath -o /out/applytrack .

# Create a smaller image containing the executable.
FROM alpine:3.22

RUN apk add --no-cache ca-certificates \
    && addgroup -S app \
    && adduser -S -G app app

WORKDIR /app

COPY --from=builder /out/applytrack /app/applytrack

USER app

ENV PORT=8080

EXPOSE 8080

ENTRYPOINT ["/app/applytrack"]