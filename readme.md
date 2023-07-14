# Signal handling when using npm as PID 1

There's various information warning against using npm as PID 1 in a container,
[though some of it is
old](https://help.heroku.com/ROG3H81R/why-does-sigterm-handling-not-work-correctly-in-nodejs-with-npm).

In particular there are claims that npm will not propagate signals to child
processes, preventing clean shutdowns e.g. via SIGTERM. However [this is no
longer true](https://github.com/npm/npm/pull/10868).

I noted that npm in some cases seems to respond to SIGTERM but does so by
immediately killing its children, preventing any application SIGTERM handlers
from running to completion. This repo contains the tests that allowed me to come
to the following conclusion:

> npm as PID 1 allows safe SIGTERM handling *when the underlying shell it
> executes scripts with* is a "well-behaved one". **In particular, dash, the
> default on Debian 6+, is *not* well-behaved.**
>
> Shells observed to be well-behaved include zsh, bash, and busybox (default on
> Alpine).
>
> Thus if your base image is
> [`node:<version>-slim`](https://github.com/nodejs/docker-node#nodeslim)
> (Debian) and you need well-behaved SIGTERM handling, then you must install
> e.g. bash and configure npm to use it:
>
> ```
> npm config set script-shell=bash
> ```
>
> Note that
> [`node:<version>-alpine`](https://github.com/nodejs/docker-node#nodealpine)
> does not suffer from this issue because its default shell is Busybox.
