FROM openjdk:8-jdk-slim

LABEL maintainer="Rolf Kleef <rolf@drostan.org>" \
  description="IATI Data Validator Engine" \
  repository="https://github.com/data4development/IATI-data-validator"

ENV ANT_VERSION    1.10.1
ENV SAXON_MAIN     9.8
ENV SAXON_VERSION  9-8-0-4J

ENV HOME /home
ENV ANT_HOME /opt/ant

WORKDIR /home

RUN apt-get update && \
  apt-get -y install --no-install-recommends wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
  tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
  rm apache-ant-${ANT_VERSION}-bin.tar.gz && \
  mv apache-ant-${ANT_VERSION} ${ANT_HOME}

RUN wget -q https://downloads.sourceforge.net/project/saxon/Saxon-HE/${SAXON_MAIN}/SaxonHE${SAXON_VERSION}.zip && \
  unzip SaxonHE${SAXON_VERSION}.zip saxon9he.jar && \
  rm SaxonHE${SAXON_VERSION}.zip && \
  mv *.jar ${ANT_HOME}/lib

ENV PATH $PATH:$ANT_HOME/bin

COPY . $HOME
VOLUME /workspace

ENTRYPOINT ["/opt/ant/bin/ant", "-e"]
CMD ["-p"]
