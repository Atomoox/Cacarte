FROM postgres
RUN apt-get update && apt-get upgrade -y
RUN apt-get install postgis -y
RUN apt-get install wget -y
RUN apt-get install unzip -y

WORKDIR /var/data

RUN wget https://cdn.discordapp.com/attachments/887693042360930367/1094629352932647015/Archive.zip 
RUN unzip Archive.zip
RUN rm Archive.zip

CMD ["postgres"]