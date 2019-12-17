FROM golang:1.13 as builder
ADD . /app
WORKDIR /app
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /app/bin/app .

# final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/bin/app ./
RUN chmod +x ./app
ENTRYPOINT ["./app"]
EXPOSE 3000
