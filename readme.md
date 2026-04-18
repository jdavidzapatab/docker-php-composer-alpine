## Docker Container for PHP 7.4 and Composer

This is a docker container for PHP 7.4 with composer installed. It can be used with
any PHP project using composer. As this image is built on top of the
[Alpine Linux](http://www.alpinelinux.org/) base image, it is tiny.

## Build

To build this image, apply any necessary changes to the Dockerfile and build the image like this:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t davidzapata/php-composer-alpine:7.4 --push .
```

## Pull it from the docker registry

To pull the docker image, you can do it with:

```bash
docker pull davidzapata/php-composer-alpine
```

## Usage

After pulling the image from the docker registry, go into any project that has a composer.json.
Then run the following commands to run php or composer:

```bash
docker run --rm -v $(pwd):/var/www davidzapata/php-composer-alpine:7.4 composer install --prefer-dist
```

> **Note on Permissions**: This image runs as a non-root user (`www-data`, UID 82) for better security. If you encounter permission issues when mounting volumes, you may need to adjust the ownership of your local files or run the container with `--user $(id -u):$(id -g)`.

To create a Laravel project using this image (for example, a blog), run:

```bash
cd my_dir
docker run --rm -v $(pwd):/var/www davidzapata/php-composer-alpine:7.4 composer create-project --prefer-dist laravel/laravel blog
cd blog
```

Using the sample laravel project, you can test it with:

```bash
docker run --rm -v $(pwd):/var/www davidzapata/php-composer-alpine:7.4 ./vendor/bin/phpunit
```

Or you can serve it using:

```bash
docker run --rm -p 80:80 -v $(pwd):/var/www davidzapata/php-composer-alpine:7.4 php -S 0.0.0.0:80 -t public
```

## Security & CVE Scanning

> **Warning**: PHP 7.4 has reached its End of Life (EOL) and no longer receives security updates from the official PHP project. This image is provided for legacy compatibility, but it is highly recommended to upgrade to a newer PHP version for modern applications.

To ensure the image is as secure as possible while maintaining PHP 7.4, this Dockerfile follows best practices:
- **Non-root user**: Runs as `www-data` (UID 82) instead of root.
- **Minimized Layers**: Consolidates commands to reduce image size and attack surface.
- **Dependency Management**: Uses the `install-php-extensions` helper for clean installation and removal of build-time dependencies.
- **OS-Wide Security Updates**: Upgrades the base OS to Alpine `v3.20` while maintaining legacy compatibility for PHP 7.4 via pinned `v3.16` repositories for necessary libraries (like `libssl1.1`).

You can scan the image for CVEs after building it using tools like [Docker Scout](https://docs.docker.com/scout/) or [Trivy](https://github.com/aquasecurity/trivy):

Using Docker Scout:
```bash
docker build -t davidzapata/php-composer-alpine:7.4 .
docker scout cves davidzapata/php-composer-alpine:7.4
```

Using Trivy:
```bash
trivy image davidzapata/php-composer-alpine:7.4
```

## As a base image

You can use it as a base image like below:

```dockerfile
FROM davidzapata/php-composer-alpine:7.4

# my docker image contents
```