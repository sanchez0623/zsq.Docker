FROM microsoft/dotnet
WORKDIR /app

COPY . /app
CMD ["dotnet","run"]

# 上面的使用完整sdk，打包出来有1.7个g
# 下面的使用runtime，打包出来只有200m

FROM microsoft/dotnet:sdk as build-dev
WORKDIR /code

COPY *.csproj /code
RUN dotnet restore

COPY . /code
RUN dotnet public -c Release -o out

FROM microsoft/dotnet:runtime
WORKDIR /app
COPY --from=build-dev /code/out /app
ENTRYPOINT ["dotnet","console.dll"]

# 有了dockerfile，就可以执行docker build进行打包成镜像
# docker build -t [imageName]
