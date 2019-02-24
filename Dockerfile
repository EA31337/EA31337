# Base.
FROM ea31337/ea-tester:dev as ea31337
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --chown=ubuntu:root . /opt/EA

# EURUSD 2018
FROM ea31337/ea-tester:EURUSD-2018-DS as eurusd-2018
# Adjust the user's UID.
ARG UID=1000
USER root
RUN usermod -u $UID ubuntu
# Copy EA files.
USER ubuntu
COPY --from=ea31337 --chown=ubuntu:root "/opt/EA" "/opt/EA"

# Build Lite version.
FROM ea31337 as ea31337-lite
WORKDIR /opt/EA
RUN make Lite
RUN make Lite-Release
RUN make Lite-Backtest

# Build Lite version with EURUSD 2018 data.
FROM eurusd-2018 as ea31337-lite-eurusd-2018
COPY --from=ea31337-lite --chown=ubuntu:root "/opt/EA" "/opt/EA"

# Build Lite version with EURUSD 2017 data.
FROM eurusd-2017 as ea31337-lite-eurusd-2017
COPY --from=ea31337-lite --chown=ubuntu:root "/opt/EA" "/opt/EA"

# Build Advanced version.
FROM ea31337 as ea31337-advanced
WORKDIR /opt/EA
RUN make Advanced
RUN make Advanced-Release
RUN make Advanced-Backtest

# Build Advanced version with EURUSD 2018 data.
FROM eurusd-2018 as ea31337-advanced-eurusd-2018
COPY --from=ea31337-advanced --chown=ubuntu:root "/opt/EA" "/opt/EA"

# Build Advanced version with EURUSD 2017 data.
FROM eurusd-2017 as ea31337-advanced-eurusd-2017
COPY --from=ea31337-advanced --chown=ubuntu:root "/opt/EA" "/opt/EA"

# Build Rider version.
FROM ea31337 as ea31337-rider
WORKDIR /opt/EA
RUN make Rider
RUN make Rider-Release
RUN make Rider-Backtest

# Build Rider version with EURUSD 2018 data.
FROM eurusd-2018 as ea31337-rider-eurusd-2018
COPY --from=ea31337-rider --chown=ubuntu:root "/opt/EA" "/opt/EA"

# Build Rider version with EURUSD 2017 data.
FROM eurusd-2017 as ea31337-rider-eurusd-2017
COPY --from=ea31337-rider --chown=ubuntu:root "/opt/EA" "/opt/EA"
