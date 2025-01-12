FROM python:3.8-slim-buster

LABEL maintainer="Christopher Nethercott" \
    description="Original by Aiden Gilmartin. Speedtest to InfluxDB data bridge."

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -q -y install --no-install-recommends apt-utils gnupg1 apt-transport-https dirmngr

# Install speedtest-cli
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
RUN echo "deb https://ookla.bintray.com/debian buster main" | tee  /etc/apt/sources.list.d/speedtest.list
RUN apt-get update && apt-get -q -y install speedtest

# Install Python packages
COPY requirements.txt /
RUN pip install -r /requirements.txt

# Clean up
RUN apt-get -q -y autoremove
RUN apt-get -q -y clean
RUN rm -rf /var/lib/apt/lists/*

# Final setup & execution
COPY . /app
WORKDIR /app
CMD ["python3", "-u", "main.py"]