FROM python:3.8.2-slim

RUN apt-get update \
    && apt-get install wget gpg -y \
    && wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
    && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
    && wget https://packages.microsoft.com/config/debian/10/prod.list \
    && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
    && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get install apt-transport-https -y \
    && apt-get update \
    && apt-get install dotnet-sdk-3.1 -y \
    && rm -rf /var/lib/apt/lists/*

CMD ["bash"]