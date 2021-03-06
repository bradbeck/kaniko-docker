package kaniko

import (
	"strings"
	"tool/cli"
	"tool/exec"
)

buildImageUrl: *"gcr.io/kaniko-project/executor" | string @tag(buildImageUrl)
buildImageTag: *"latest" | string                         @tag(buildImageTag)
dockerFile:    *"docker/Dockerfile" | string              @tag(dockerFile)

command: {
	help: exec.Run & {
		cmd: ["docker", "run", "--rm", "\(buildImageUrl):\(buildImageTag)", "--help"]
	}
	build: {
		pwd: exec.Run & {
			cmd: ["pwd"]
			stdout: string
			path:   strings.TrimSpace(stdout)
		}
		user: exec.Run & {
			cmd: ["whoami"]
			stdout: string
			name:   strings.TrimSpace(stdout)
		}
		digestFile:  *"digest-file" | string                           @tag(digestFile)
		context:     *"\(pwd.path)/context" | string                   @tag(context)
		destination: *"ttl.sh/\(user.name)/kaniko-docker:10m" | string @tag(destination)
		run:         exec.Run & {
			cmd: ["docker", "run", "--rm",
				"-v", "\(context):/workspace",
				"\(buildImageUrl):\(buildImageTag)",
				"--dockerfile", "\(dockerFile)",
				"--destination", "\(destination)",
				"--digest-file", "\(digestFile)",
				"--image-name-tag-with-digest-file", "image-name-tag-digest.txt",
				"--image-name-with-digest-file", "image-name-digest.txt",
				"--cache=false",
				"--reproducible",
				"--force"]
		}
		localDigest: exec.Run & {
			$after: run
			cmd: ["cat", "\(context)/\(digestFile)"]
			stdout: string
			value:  strings.TrimSpace(stdout)
		}
		registryDigest: exec.Run & {
			$after: run
			cmd: ["crane", "digest", "\(destination)"]
			stdout: string
			value:  strings.TrimSpace(stdout)
		}
		verify: cli.Print & {
			text: """

            # Inputs

            buildImageUrl: \(buildImageUrl)
            buildImageTag: \(buildImageTag)
            dockerFile   : \(dockerFile)
            digestFile   : \(digestFile)
            context      : \(context)
            destination  : \(destination)

            # Results

            digests
              local   : \(localDigest.value)
              registry: \(registryDigest.value)
            
            """
		}
	}
}
