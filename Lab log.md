## Telematic Applications

# HTTP Lab

*Academic year 2024-2025*

---

## Introduction

### Symlinks and scripts

A symlink to the `apache2` executable was created in `~/.local/bin` for
convenience.

### Privacy and variables

For privacy, some measurements were taken to hide some private data using
environment variables and placeholders.

The environment variables used were

* `HTTPD_ROOT`, set to the absolute path to the `httpd` folder in this repo
* `LISTEN_PORT`, set to `9xxx`, where `xxx` are the last 3 digits of my `UID`
* `HOSTNAME`, set to the value of the environment variable `HOSTNAME`

Run the `env.sh` script from the repo root to set these variables. Remember
to run it with `. env.sh` so it can properly set environment variables.

## Part 1: Server Configuration

### 1.1. Directory setup

This was easily done following the instructions, moving the necessary files and
creating the subdirectories in the `httpd` directory in this repository.

```text
httpd/
├── apache2.conf
├── mime.types
├── defaultdocs/
├── log/
├── vhost1/
│   ├── docs/
│   └── log/
└── vhost2/
    ├── docs/
    └── log/
```

### 1.2. Config file setup

The `apache2.conf` was modified as instructed, using environment variable
placeholders according to spec where it seemed appropriate:

* The `ServerRoot` option was set to the value of the aforementioned
  `HTTPD_ROOT` environment variable:

    ```apacheconf
    ServerRoot ${HTTPD_ROOT}
    ```

* The `ServerName` option was set to a value depending on the running machine:

    ```apacheconf
    ServerName ${HOSTNAME}.lab.it.uc3m.es
    ```

* The `Listen` option was set to the value of the aforementioned
  `LISTEN_PORT` environment variable:

    ```apacheconf
    Listen ${LISTEN_PORT}
    ```

### 1.3. Create a simple html webpage

The file was created with the following contents (in English and indented):

```html
<html>
    <body>
        Hello World!
    </body>
</html>
```

### 1.4. Start the server

As mentioned in the introduction, the server executable was symlinked to the
`.local/bin` folder, which is in the path, for convenience. The server was run,
from the repo root, using the following command, which also makes use of
environment variables:

```sh
apache2 -f "$PWD/httpd/apache2.conf"
```

The server was started with no issues.

### 1.5. Access the webpage

This gave me a huge headache. Since I always work remotely, using my laptop and
remote terminals, I tried accessing the webpage at the following URL:

```
http://<HOSTNAME>:<LISTEN_PORT>/aptel.html
```

Where `<HOSTNAME>` and `<LISTEN_PORT>` were the hostname of the machine where
the server was started and the port as set before. However, my local browser
completely failed to retrieve the page requested.

After about an hour of tweaking the configuration, trying to use absolute IP
addresses and paths instead of names and environment variables, I tried to
`curl` the webpage from the same machine that was running the server, and I
finally got my expected response. As it turns out, the server I started would
not respond to requests from my machine, probably due to firewall rules.
Accessing the server through a web browser on the lab machines also worked.

Upon `curl` of the webpage created
(`http://<HOSTNAME>:<LISTEN_PORT>/aptel.html`), we got the contents of the html
file we created before.

```html
<html>
    <body>
        Hello World!
    </body>
</html>
```

Upon `curl` of the root (`http://<HOSTNAME>:<LISTEN_PORT>/`), we got a 404
error along with an html file describing the issue:

```html
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL was not found on this server.</p>
</body></html>
```

