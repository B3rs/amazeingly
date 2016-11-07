# A-Maze-ingly test challenge
### By Marco Bersani
First of all build the container image starting from the included Dockerfile
```shell
docker build -t marcobersani:amazeingly .
```
When the image is complete create and run a new container in interactive mode to obtain a shell and pass it a volume to mount (in this case it will mount the local resources folder to /resources)
```shell
docker run --name marcobersani -it -v $(pwd)/resources:/resources marcobersani:amazeingly sh
```

now you can launch the application with
```shell
ruby start.rb --file /resources/map.json --room-id 2 --objects 'Knife,Potted Plant'
```

The arguments passed are respectively:
1. the map file path (remember: you mounted it inside /resources so it should be /resources/map.json)
2. the starting room id
3. a comma separated string with the objects to search

#### Editing the input file:
You can edit with a JSON editor the file `map.json` in the resources folder (on the host machine)
then simply relaunch the application inside the container