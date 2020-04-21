FROM mcr.microsoft.com/dotnet/core/sdk:3.1
RUN apt-get update \
    && apt-get install -y \
        python3 \
    && rm -rf /var/lib/apt/lists/*