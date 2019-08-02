# httpbash

> Do you think there will be security implications?

> Might as well run it as root.

# Running 

```
docker build -t httpbash .
docker run -v "$PWD/src:/app/src" -p 8808:80 --rm httpbash 
``` 

