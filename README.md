# Realworld app IHP

## Docker

build :
```
docker build -t realworld-app-ihp .
```

run :
```
docker run -p 8000:8000 -v $(pwd)/Config:/app/Config:ro realworld-app-ihp 
```

you can pass the `ENV` environment variable to switch between Production (default) & Development mode.

```
docker run -e ENV=dev -p 8000:8000 -v $(pwd)/Config:/app/Config:ro realworld-app-ihp 
```

NB : we have to mount the `./Config` folder so the app can access the AES key (used for cookies encryption).
