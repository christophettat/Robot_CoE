FROM ppodgorsek/robot-framework:latest 

LABEL description Robot Framework in Docker.

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server

ENV EXCELLIB_VERSION 2.0.0
ENV PDF2TEXTLIBRARY_VERSION 1.0.1
ENV SELENIUM2LIBRARY_VERSION 3.0.0
ENV REQUESTS_VERSION 2.25.1
ENV REQUESTS_LIBRARY_VERSION 0.8.0
ENV JIRA_VERSION 3.0.1
ENV PYPDF2_VERSION 1.26.0
ENV ATLASSIAN_PYTHON_API_VERSION 3.14.1
ENV PABOT_VERSION 2.6.0
ENV SELENIUMLIBRARY_VERSION 6.1.2  
USER root

# install kafka version required by robot kafkalib
#RUN dnf install -y librdkafka librdkafka-devel python-confluent-kafka

RUN dnf makecache -y \
&& dnf install -y --setopt=protected_packages=, \
    gcc \ 
    g++ \
    curl \
    unzip \
    libaio \
    python-confluent-kafka\
    libxml2-devel\
    libxslt-devel\
    python3-devel\
    librdkafka-devel \
    libffi-devel \
    java-1.8.0-openjdk\
# Install Robot Framework and Selenium Library
&& dnf clean all \
&& pip3 install \
    --no-cache-dir \
    pyOpenSSL==21.0.0 \
    robotframework-seleniumlibrary==$SELENIUMLIBRARY_VERSION \
    robotframework-excellib==$EXCELLIB_VERSION \
    robotframework-selenium2library==$SELENIUM2LIBRARY_VERSION \
    robotframework-pdf2textlibrary==$PDF2TEXTLIBRARY_VERSION \
    robotframework-archivelibrary \
    robotframework-requests==$REQUESTS_LIBRARY_VERSION \
    PyPDF2==$PYPDF2_VERSION \
    PyYAML \
    JayDeBeApi \
    lxml\
    xlrd\
    suds-py3\ 
    requests-pkcs12 \
    influxdb \
    jwt \
    jira==$JIRA_VERSION \
    requests==$REQUESTS_VERSION \
    atlassian-python-api==$ATLASSIAN_PYTHON_API_VERSION \
    robotframework-jsonlibrary==0.3.1 \
    robotframework-httplibrary==0.4.2 \
    robotframework-confluentkafkalibrary==1.7.0.post1 \
    robotremoteserver \
    redis==4.1.4 \
    robotframework-crypto \
    cx-Oracle \
    oracledb==1.4.2 \
    pymssql==2.2.11 \
    pyotp \
&& pip3 install -I \
    --no-cache-dir \
    robotframework-pabot==$PABOT_VERSION 

# Install oracle client
RUN cd /tmp && \
    curl -o instantclient-basiclite.zip https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -SL && \
    unzip instantclient-basiclite.zip && \
    mv instantclient*/ /usr/lib/instantclient && \
    rm instantclient-basiclite.zip && \
    ln -s /usr/lib/instantclient/libclntsh.so.21.1 /usr/lib/libclntsh.so && \
    ln -s /usr/lib/instantclient/libocci.so.21.1 /usr/lib/libocci.so && \
    ln -s /usr/lib/instantclient/libociicus.so /usr/lib/libociicus.so && \
    ln -s /usr/lib/instantclient/libnnz21.so /usr/lib/libnnz21.so && \
    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1 && \
    ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 && \
    ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2

ENV LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server:/usr/lib/instantclient


    
#COPY ./ojdbc8.jar /lib/ojdbc8.jar
#COPY ./ojdbc6.jar /lib/ojdbc6.jar

# patching with latest remoteserver that supports python 3.10+
ADD https://raw.githubusercontent.com/robotframework/PythonRemoteServer/master/src/robotremoteserver.py /usr/local/lib/python3.10/site-packages/pabot/
ADD https://raw.githubusercontent.com/robotframework/PythonRemoteServer/master/src/robotremoteserver.py /usr/local/lib/python3.10/site-packages/

RUN chmod 644 /usr/local/lib/python3.10/site-packages/pabot/robotremoteserver.py
RUN chmod 644 /usr/local/lib/python3.10/site-packages/robotremoteserver.py


# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
