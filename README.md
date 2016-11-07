# A-Maze-ingly test challenge
By Marco Bersani

### Installation

First of all build the container image starting from the included Dockerfile
```shell
docker build -t marcobersani:amazeingly .
```
When the image is complete create and run a new container and pass it a volume to mount (in this case it will mount the local resources folder to /resources). 
The `-it -d` options creates an interactive and detached shell that keeps the container running in background and the `-v $(pwd)/resources:/resources` 
mounts the local resources folder to `/resources` inside the container: 
```shell
docker run --name amazeingly -it -d -v $(pwd)/resources:/resources marcobersani:amazeingly sh
```

Now you can execute the application with:
```shell
docker exec amazeingly bin/amazeingly --file /resources/map.json --room-id 2 --objects 'Knife,Potted Plant'
```

### Parameters 

The supported parameters are:
- `--file -f` the map file path (remember: you mounted it inside /resources so it should be /resources/map.json)
- `--room-id -r` the starting room id
- `--objects -o` a comma separated string containing objects to search

the default values for these parameters are:
```
--file '/resources/map.json' --room-id 1 --objects ''
```

so running:
```shell
docker exec amazeingly bin/amazeingly
```
is the same as running: 
```
docker exec amazeingly bin/amazeingly --file '/resources/map.json' --room-id 1 --objects ''
```
You can also see all the available options running 
```
docker exec amazeingly bin/amazeingly -h
```

### Editing the input json file:
If you used the above docker volumes configuration you can edit with an editor the file `resources/map.json` (on the host machine)
and then simply re-execute the application.

### Rooms mapping 
The `maps.json` included has a simple rooms geography with a small cycle:
```
3 ---- 2 ---- 4
       |      |
       |      |
       1      |
       |      |
       |      |
       5 ---- 7
       |
       |
       6
```
Where:
- `Knife` is in room 3
- `Potted Plant` is in room 4
- `Laptop` is in room 7 (yeah it's in the garden)

You can find (and use) the default mapping inside the `resources/default_map.json` file.

### Running tests
You can run tests with `docker exec amazeingly rake test`