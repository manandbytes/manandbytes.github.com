FROM manandbytes/debian:stable
MAINTAINER Mykola Nikishov <mn@mn.com.ua>

RUN apt-get update
RUN apt-get -y install bundler
RUN apt-get -y install zlib1g-dev # required to build nokogiri

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./Gemfile /usr/src/app/
RUN bundler update

# run jekyll
EXPOSE 4000
CMD jekyll serve -d /_site --watch --incremental --force_polling -H 0.0.0.0 -P 4000
