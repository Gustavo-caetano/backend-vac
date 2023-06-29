FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /App
COPY --from=build-env /App/out .

# Adicionar etapas para configuração HTTPS
# Copiar o certificado SSL para o contêiner (substitua "cert.pfx" pelo nome do seu certificado)
COPY aspnetapp.pfx /App/aspnetapp.pfx

# Definir a variável de ambiente ASPNETCORE_Kestrel__Certificates__Default__Path com o caminho para o certificado SSL
ENV ASPNETCORE_Kestrel__Certificates__Default__Path=/App/aspnetapp.pfx
ENV ASPNETCORE_Kestrel__Certificates__Default__Password=12345678

ENTRYPOINT ["dotnet", "SergipeVac.dll"]

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
# WORKDIR /App

# # Copy everything
# COPY . ./
# # Restore as distinct layers
# RUN dotnet restore
# # Build and publish a release
# RUN dotnet publish -c Release -o out

# # Build runtime image
# FROM mcr.microsoft.com/dotnet/aspnet:6.0
# WORKDIR /App
# COPY --from=build-env /App/out .
# ENTRYPOINT ["dotnet", "SergipeVac.dll"]
