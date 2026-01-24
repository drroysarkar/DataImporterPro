# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT}
EXPOSE 10000

# Build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything
COPY . .

# Move into the project folder
WORKDIR /src/DataImporterSite

# Restore & publish
RUN dotnet restore DataImporterSite.csproj
RUN dotnet publish DataImporterSite.csproj -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "DataImporterSite.dll"]
