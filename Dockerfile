FROM openjdk:11-jdk-slim

LABEL maintainer="Rolf Kleef <rolf@data4development.nl>" \
  description="IATI Data Validator Engine" \
  repository="https://github.com/data4development/IATI-data-validator"

# To be adapted in the cluster or runtime config
ENV \
    API=none \
    BUCKET_SRC=dataworkbench-iati \
    BUCKET_FB=dataworkbench-iatifeedback \
    BUCKET_JSON=dataworkbench-json \
    BUCKET_SVRL=dataworkbench-svrl
# ----------

# To build the container
ENV \
    ANT_VERSION=1.10.1 \
    SAXON_VERSION=9.8.0-14 \
    WEBHOOK_VERSION=2.6.8 \
    \
    HOME=/home \
    ANT_HOME=/opt/ant \
    SAXON_HOME=/opt/ant

WORKDIR $HOME

RUN apt-get update && \
  apt-get -y install --no-install-recommends wget libxml2-utils curl libgnutls-openssl27 jq libjq1 libonig5 msmtp && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -q https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
  tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
  rm apache-ant-${ANT_VERSION}-bin.tar.gz && \
  mv apache-ant-${ANT_VERSION} ${ANT_HOME}

RUN wget -q https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/${SAXON_VERSION}/Saxon-HE-${SAXON_VERSION}.jar && \
  mv *.jar ${ANT_HOME}/lib

RUN wget -q https://github.com/adnanh/webhook/releases/download/${WEBHOOK_VERSION}/webhook-linux-amd64.tar.gz && \
  tar -xzf webhook-linux-amd64.tar.gz --strip 1 && \
  rm webhook-linux-amd64.tar.gz

ENV PATH $PATH:$ANT_HOME/bin

VOLUME /workspace

COPY . $HOME
RUN mkdir -p $HOME/tests/xspec && \
  chmod go+w $HOME/tests/xspec && \
  mkdir -p /work && \
  chmod go+w /work && \
  ln -s /workspace /work/space

EXPOSE 9000

ENTRYPOINT ["/opt/ant/bin/ant", "-e"]
CMD ["-p"]
