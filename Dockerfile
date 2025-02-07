# Base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# Environment variables to ensure WebSockets & HTTP/2 support
ENV DOTNET_SYSTEM_NET_HTTP_SOCKETSHTTPHANDLER_HTTP2SUPPORT=true
ENV DOTNET_USE_POLLING_FILE_WATCHER=1
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_FORWARDEDHEADERS_ENABLED=true

# Build image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy project files and restore dependencies
COPY ["chatapptestnotborken/chatapptestnotborken/chatapptestnotborken.csproj", "chatapptestnotborken/chatapptestnotborken/"]
COPY ["chatapptestnotborken/chatapptestnotborken.Client/chatapptestnotborken.Client.csproj", "chatapptestnotborken/chatapptestnotborken.Client/"]
RUN dotnet restore "chatapptestnotborken/chatapptestnotborken/chatapptestnotborken.csproj"

# Copy everything and build
COPY . .
WORKDIR "/src/chatapptestnotborken/chatapptestnotborken"
RUN dotnet build "chatapptestnotborken.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish the app
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "chatapptestnotborken.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Entry point
ENTRYPOINT ["dotnet", "chatapptestnotborken.dll"]
