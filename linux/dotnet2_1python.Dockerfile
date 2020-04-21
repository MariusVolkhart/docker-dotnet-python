FROM mcr.microsoft.com/dotnet/core/sdk:2.1
RUN apt-get update \
    && apt-get install -y \
        python3 \
    && rm -rf /var/lib/apt/lists/*