# Subito.it test challenge
### By Marco Bersani
First of all build the container image starting from the included Dockerfile
```shell
docker build -t marcobersani:subito .
```
When the image is complete run it in interactive mode to obtain a shell and pass it a volume to mount (in this case it will mount the local resources folder to /resources)
```shell
docker run --name marcobersani -i -v $(pwd)/resources:/resources marcobersani:subito /bin/bash
```

now you can launch the application with
```shell
ruby ./lib/start.rb /resources/map.json 2 "Knife,Potted Plant"
```

The arguments passed are respectively:
1. the map file path (remember: you mounted it inside /resources so it should be /resources/map.json)
2. the starting room id
3. a comma separated string with the objects to search
