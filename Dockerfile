FROM ppodgorsek/robot-framework:3.7.0


LABEL description Robot Framework in Docker.

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server

ENV EXCELLIB_VERSION 2.0.0
ENV PDF2TEXTLIBRARY_VERSION 1.0.1
ENV SELENIUM2LIBRARY_VERSION 3.0.0
ENV REQUESTS_VERSION 2.25.1
ENV REQUESTS_LIBRARY_VERSION 0.8.0

USER root

RUN apk --no-cache upgrade \
  && apk --no-cache --virtual .build-deps add \
    gcc \
    g++\
    libxml2-dev\
    libxslt-dev\
# Install Robot Framework and Selenium Library
&& pip3 install \
    --no-cache-dir \
    robotframework-excellib==$EXCELLIB_VERSION \
    robotframework-selenium2library==$SELENIUM2LIBRARY_VERSION \
    robotframework-pdf2textlibrary==$PDF2TEXTLIBRARY_VERSION \
    robotframework-archivelibrary \
    PyYAML \
    JayDeBeApi \
    lxml\
    xlrd\
    suds-py3\
    requests==$REQUESTS_VERSION \
    robotframework-requests==$REQUESTS_LIBRARY_VERSION \
&& apk del --no-cache --update-cache .build-deps

RUN set -x && apk add --no-cache openjdk8
#COPY ./ojdbc8.jar /lib/ojdbc8.jar
#COPY ./ojdbc6.jar /lib/ojdbc6.jar

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
