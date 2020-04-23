FROM python:3.8-windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest -Uri https://dot.net/v1/dotnet-install.ps1 -OutFile 'dotnet-install.ps1'; \
    ./dotnet-install.ps1 -Channel 2.1; \
	./dotnet-install.ps1 -Channel 3.1; \