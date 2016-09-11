FROM manandbytes/debian:stable
MAINTAINER Mykola Nikishov <mn@mn.com.ua>

ARG APT_PROXY_HTTP="http://172.17.0.1:3142"
ARG APT_PROXY_HTTPS="https://172.17.0.1:3142"

RUN echo 'Acquire::http { Proxy "$APT_PROXY_HTTP"; };' > /etc/apt/apt.conf.d/01proxy && \
 echo 'Acquire::https { Proxy "$APT_PROXY_HTTPS"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get -y --no-install-recommends install \
 bundler \
 g++ \
 git \
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
