# Running Kaniko from Docker

## Example

```bash
$ cue cmd build
...

# Inputs

buildImageUrl: gcr.io/kaniko-project/executor
buildImageTag: latest
dockerFile   : /docker/Dockerfile
digestFile   : digest-file
context      : /.../kaniko-docker/context
destination  : ttl.sh/.../kaniko-docker:10m

# Results

digests
    local   : sha256:aaa...
    registry: sha256:aaa...

```

## References

* <https://github.com/GoogleContainerTools/kaniko#running-kaniko>
* <https://github.com/GoogleContainerTools/kaniko/blob/main/run_in_docker.sh>
* <https://cuelang.org>
* <https://blog.patapon.info/cue-tool/>
* <https://pkg.go.dev/cuelang.org/go/pkg/tool/exec>
