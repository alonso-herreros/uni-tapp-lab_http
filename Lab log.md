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

Run the `env_set.sh` script from the repo root to set these variables. Remember
to run it with `. env_set.sh` so it can properly set environment variables.

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

## Part 2: HTTP Requests and Responses

In this section, commands were first written in batch in `.http` files in the
`cmds` folder, and then piped into the server using `netcat` (or `nc`). The
same sequence of commands can be sent manually using `telnet`, as instructed in
the lab guide.

> **Note**
>
> Note that these command files must have `CRLF` (DOS-style) line endings.
> Otherwise, the server will not understand the commands and it will respond
> with `400 Bad Request`

### 2.6. Requests through the command line

Requests were first made with HTTP/0.9 and then with HTTP/1.0 to get the
`/aptel.html` and `/` (root) resources.

#### 2.6.1 Requests with HTTP/0.9

First, both requests were made with HTTP/0.9, with the following commands and
responses

```http
GET /aptel.html
```

```html
<html>
    <body>
        Hello World!
    </body>
</html>
```

```http
GET /
```

```html
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL was not found on this server.</p>
</body></html>
```

As we can see, the responses we get are in pure html format, **with no
headers**. Furthermore, the connections were closed immediately after the
transaction, as it's done in HTTP/0.9.

#### 2.6.2. Requests with HTTP/1.0

Both resources were requested again, this time using HTTP/1.0 with the
following commands and responses:

```http
GET /aptel.html HTTP/1.0
​
```

Note the empty line at the end. It is required to send an empty line to signal
the end of the headers section, which are supported in HTTP/1.0.

```http
HTTP/1.1 200 OK
Date: Thu, 12 Dec 2024 17:53:49 GMT
Server: Apache/2.4.57 (Debian)
Last-Modified: Tue, 10 Dec 2024 12:26:47 GMT
ETag: "3b-628e99848b804"
Accept-Ranges: bytes
Content-Length: 59
Connection: close
Content-Type: text/html

<html>
    <body>
        Hello World!
    </body>
</html>
```

As we can see, this time the server responded with a few headers:

* `Date`
* `Server`
* `Last-Modified`
* `ETag`
* `Accept-Ranges`
* `Content-Length`
* `Content-Type`
* `Connection`

After an **empty line**, which signals the end of the header section, the same
html file from before was included.

The root resource was also requested using HTML/1.0

```http
GET / HTTP/1.0
​
```

Note again the empty line at the end.

The response was similar to the one obtained with HTTP/0.9, but including
headers.

```http
HTTP/1.1 404 Not Found
Date: Thu, 12 Dec 2024 17:54:02 GMT
Server: Apache/2.4.57 (Debian)
Content-Length: 196
Connection: close
Content-Type: text/html; charset=iso-8859-1

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL was not found on this server.</p>
</body></html>
```

In this case we got a few headers less, only including the following list:

* `Date`
* `Server`
* `Content-Length`
* `Content-Type`
* `Connection`

### 2.7. Requests with HTTP/1.1

In HTTP/1.1, the `Host` header is mandatory. The request for the `/aptel.html`
resource is as follows:

```http
GET /aptel.html HTTP/1.1
Host: localhost
​
```

The response was almost identical to the one obtained with HTTP/1.0, except for
the `Date` header contente and the **exclusion of the `Connection: close`
header**. The server **did not close the connection** because, by default,
HTTP/1.1 connections are persistent.

In order to request that the connection be closed immediately, we can include
the `Connection: close` header in the request:

```http
GET /aptel.html HTTP/1.1
Host: localhost
Connection: close
​
```

When this request is sent, the server added the `Connection: close` header to
their response, and then closed the connection immediately after sending the
response, just like in section 2.6.2

