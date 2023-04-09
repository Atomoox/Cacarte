FROM golang

RUN apt-get update && apt-get install -y git

COPY .netrc /root/.netrc

WORKDIR /go/src/app

RUN git clone https://github.com/Yuyugnat/sae-shortest-path-api.git .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["sh", "-c", "go run main.go"]