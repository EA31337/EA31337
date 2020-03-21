# Prepare source code.
FROM ea31337/ea-tester:dev as ea31337-src
MAINTAINER kenorb
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --chown=ubuntu:root ./ /opt/src
RUN cp '/home/ubuntu/.wine/drive_c/Program Files/MetaTrader 4/metaeditor.exe' /opt/src/

# Build Lite version.
FROM ea31337-src as ea31337-lite
WORKDIR /opt/src
RUN make Lite
RUN make Lite-Release
RUN make Lite-Backtest
RUN make Lite-Optimize

# Build Advanced version.
FROM ea31337-src as ea31337-advanced
WORKDIR /opt/src
RUN make Advanced
RUN make Advanced-Release
RUN make Advanced-Backtest
RUN make Advanced-Optimize

# Build Rider version.
FROM ea31337-src as ea31337-rider
WORKDIR /opt/src
RUN make Rider
RUN make Rider-Release
RUN make Rider-Backtest
RUN make Rider-Optimize

# Build all versions.
FROM ea31337-src as ea31337
MAINTAINER kenorb
WORKDIR /opt/EA
COPY --from=ea31337-lite --chown=ubuntu:root "/opt/src/*.ex?" "/opt/EA/"
COPY --from=ea31337-advanced --chown=ubuntu:root "/opt/src/*.ex?" "/opt/EA/"
COPY --from=ea31337-rider --chown=ubuntu:root "/opt/src/*.ex?" "/opt/EA/"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="EA31337" \
      org.label-schema.description="Multi-strategy advanced trading robot for Forex." \
      org.label-schema.url="https://github.com/EA31337/EA31337" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/EA31337/EA31337" \
      org.label-schema.vendor="FX31337" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

# EURUSD 2017
FROM ea31337/ea-tester:EURUSD-2017-DS as ea31337-eurusd-2017
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --from=ea31337 --chown=ubuntu:root "/opt/EA" "/opt/EA"

# EURUSD 2018
FROM ea31337/ea-tester:EURUSD-2018-DS as ea31337-eurusd-2018
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --from=ea31337 --chown=ubuntu:root "/opt/EA" "/opt/EA"

# EURUSD 2019
FROM ea31337/ea-tester:EURUSD-2019-DS as ea31337-eurusd-2019
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --from=ea31337 --chown=ubuntu:root "/opt/EA" "/opt/EA"
