# Base.
FROM ea31337/ea-tester:dev as ea31337-src
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --chown=ubuntu:root ./ /opt/src

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
WORKDIR /opt/EA
COPY --from=ea31337-lite --chown=ubuntu:root "/opt/src/*.ex?" "/opt/EA/"
COPY --from=ea31337-advanced --chown=ubuntu:root "/opt/src/*.ex?" "/opt/EA/"
COPY --from=ea31337-rider --chown=ubuntu:root "/opt/src/*.ex?" "/opt/EA/"

# EURUSD 2017
FROM ea31337/ea-tester:EURUSD-2017-DS as ea31337-eurusd-2017
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --from=ea31337 --chown=ubuntu:root "/opt/EA" "/opt/EA"
COPY ./docker/optimization/_rules /opt/rules

# EURUSD 2018
FROM ea31337/ea-tester:EURUSD-2018-DS as ea31337-eurusd-2018
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --from=ea31337 --chown=ubuntu:root "/opt/EA" "/opt/EA"
COPY ./docker/optimization/_rules /opt/rules
