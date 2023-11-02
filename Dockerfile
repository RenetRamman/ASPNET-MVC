FROM ubuntu:22.04 AS builder

# install the .NET 7 SDK from the Ubuntu archive
RUN apt-get update && apt-get install -y dotnet7 ca-certificates && apt-get install -y dotnet-sdk-7.0

# add your application code
WORKDIR /source
COPY ./source/ /app

WORKDIR /app

# publish your ASP.NET app
RUN dotnet publish -c Release -o /app --self-contained false

FROM ubuntu/dotnet-aspnet:7.0-23.04_edge

WORKDIR /app
COPY --from=builder /app ./

ENV PORT 8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "/app/bin/Release/net7.0/aspnet-cv.dll"]