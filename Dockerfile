#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["WepApp01/WepApp01.csproj", "WepApp01/"]
RUN dotnet restore "WepApp01/WepApp01.csproj"
COPY . .
WORKDIR "/src/WepApp01"
RUN dotnet build "WepApp01.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WepApp01.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WepApp01.dll"]