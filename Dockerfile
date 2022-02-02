#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ASP6/ASP6.csproj", "ASP6/"]
RUN dotnet restore "ASP6/ASP6.csproj"
COPY . .
WORKDIR "/src/ASP6"
RUN dotnet build "ASP6.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ASP6.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ASP6.dll"]