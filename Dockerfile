FROM manandbytes/debian:stable
MAINTAINER Mykola Nikishov <mn@mn.com.ua>

RUN apt-get update && apt-get -y --no-install-recommends install \
 bundler \
 g++ \
 make \
 ruby-dev \
 zlib1g-dev # required to build nokogiri \
 && apt-get clean

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./Gemfile /usr/src/app/
RUN bundler update

RUN apt-get clean

# run jekyll
EXPOSE 4000
CMD jekyll serve -d /_site --watch --incremental --force_polling -H 0.0.0.0 -P 4000
