# Base.
FROM ea31337/ea-tester:dev as ea31337
USER ubuntu
COPY --chown=ubuntu:root . /opt/EA
WORKDIR /opt/EA

# Build Lite version.
FROM ea31337 as ea31337-lite
RUN make Lite
RUN make Lite-Release
RUN make Lite-Backtest

FROM ea31337/ea-tester:EURUSD-2018-DS as ea31337-lite-eurusd-2018
COPY --from=ea31337-lite --chown=ubuntu:root ["/opt/EA", "/opt/EA"]

# Build Advanced version.
FROM ea31337 as ea31337-advanced
RUN make Advanced
RUN make Advanced-Release
RUN make Advanced-Backtest

FROM ea31337/ea-tester:EURUSD-2018-DS as ea31337-advanced-eurusd-2018
COPY --from=ea31337-advanced --chown=ubuntu:root ["/opt/EA", "/opt/EA"]

# Build Rider version.
FROM ea31337 as ea31337-rider
RUN make Rider
RUN make Rider-Release
RUN make Rider-Backtest

FROM ea31337/ea-tester:EURUSD-2018-DS as ea31337-rider-eurusd-2018
COPY --from=ea31337-rider --chown=ubuntu:root ["/opt/EA", "/opt/EA"]
