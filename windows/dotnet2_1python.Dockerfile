FROM mcr.microsoft.com/dotnet/core/sdk:2.1

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV PYTHON_VERSION 3.8.2
ENV PYTHON_RELEASE 3.8.2

RUN $url = ('https://www.python.org/ftp/python/{0}/python-{1}-amd64.exe' -f $env:PYTHON_RELEASE, $env:PYTHON_VERSION); \
	Write-Host ('Downloading {0} ...' -f $url); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Uri $url -OutFile 'python.exe'; \
	\
	Write-Host 'Installing ...'; \
# https://docs.python.org/3.5/using/windows.html#installing-without-ui
	Start-Process python.exe -Wait \
		-ArgumentList @( \
			'/quiet', \
			'InstallAllUsers=1', \
			'TargetDir=C:\Python', \
			'PrependPath=1', \
			'Shortcuts=0', \
			'Include_doc=0', \
			'Include_pip=0', \
			'Include_test=0' \
		); \
	\
# the installer updated PATH, so we should refresh our local value
	$env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
	\
	Write-Host 'Verifying install ...'; \
	Write-Host '  python --version'; python --version; \
	\
	Write-Host 'Removing ...'; \
	Remove-Item python.exe -Force; \
	\
	Write-Host 'Complete.'

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 20.0.2
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/d59197a3c169cef378a22428a3fa99d33e080a5d/get-pip.py
ENV PYTHON_GET_PIP_SHA256 421ac1d44c0cf9730a088e337867d974b91bdce4ea2636099275071878cc189e

RUN Write-Host ('Downloading get-pip.py ({0}) ...' -f $env:PYTHON_GET_PIP_URL); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Uri $env:PYTHON_GET_PIP_URL -OutFile 'get-pip.py'; \
	Write-Host ('Verifying sha256 ({0}) ...' -f $env:PYTHON_GET_PIP_SHA256); \
	if ((Get-FileHash 'get-pip.py' -Algorithm sha256).Hash -ne $env:PYTHON_GET_PIP_SHA256) { \
		Write-Host 'FAILED!'; \
		exit 1; \
	}; \
	\
	Write-Host ('Installing pip=={0} ...' -f $env:PYTHON_PIP_VERSION); \
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		('pip=={0}' -f $env:PYTHON_PIP_VERSION) \
	; \
	Remove-Item get-pip.py -Force; \
	\
	Write-Host 'Verifying pip install ...'; \
	pip --version; \
	\
	Write-Host 'Complete.'