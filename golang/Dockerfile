FROM golang

RUN apt-get update && apt-get install -y git

WORKDIR /go/src/app

RUN git clone https://github.com/Yuyugnat/sae-shortest-path-api.git .

RUN go get -d -v ./...
RUN go install -v ./...

RUN echo '{\n "host": "172.20.128.2", \n "port": 5432, \n "user": "tp1", \n "password": "tp12023", \n "dbname": "sae" \n}' > /go/src/app/connection/config.json

CMD ["sh", "-c", "go run main.go"]