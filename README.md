# Running Kaniko from Docker

## Example

```bash
./run_in_docker.sh /docker/Dockerfile "$(pwd)"/context ttl.sh/"$USER"/kaniko-docker
```

## Verifying

```bash
$ crane digest ttl.sh/"$USER"/kaniko-docker:latest
sha256:f25697cb9efb03943ca55efcb2a75c1b3a17f0db4a5359517728fc7b866b98fb
$ cat context/digest-file
sha256:f25697cb9efb03943ca55efcb2a75c1b3a17f0db4a5359517728fc7b866b98fb
```

## References

* <https://github.com/GoogleContainerTools/kaniko#running-kaniko>
* <https://github.com/GoogleContainerTools/kaniko/blob/main/run_in_docker.sh>
