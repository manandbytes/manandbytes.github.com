FROM manandbytes/debian:stable
MAINTAINER Mykola Nikishov <mn@mn.com.ua>

RUN echo 'Acquire::http { Proxy "http://172.17.42.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy && \
 echo 'Acquire::https { Proxy "http://172.17.42.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get -y --no-install-recommends install \
 bundler \
 g++ \
 make \
 ruby-dev \
 zlib1g-dev # required to build nokogiri \
 && apt-get clean

# to run as non-root user
ENV USER jekyll
ENV USERHOME /home/${USER}
RUN useradd ${USER}
RUN mkdir ${USERHOME} && chown -R ${USER}:jekyll ${USERHOME}

WORKDIR ${USERHOME}

ADD Gemfile ${USERHOME}/
RUN bundler install

# run jekyll
USER ${USER}
EXPOSE 4000

ENTRYPOINT ["jekyll"]
CMD ["server", "--port", "4000", "--host", "0.0.0.0", "--trace", "--incremental", "--profile", "--watch", "--drafts", "--verbose"]
