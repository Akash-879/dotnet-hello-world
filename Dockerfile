FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /src

COPY ["hello-world-api/hello-world-api.csproj", "hello-world-api/"]
RUN dotnet restore "hello-world-api/hello-world-api.csproj"

COPY . .
WORKDIR "/src/hello-world-api"
RUN dotnet publish "hello-world-api.csproj" -c Release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:2.1 AS base
WORKDIR /app

ENV ASPNETCORE_URLS=http://0.0.0.0:5000
EXPOSE 5000

COPY --from=build /app .

ENTRYPOINT ["dotnet", "hello-world-api.dll"]