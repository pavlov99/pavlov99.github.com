+++
date = "2016-02-20T23:06:18+08:00"
description = "This article shows advantages of using version manager for Go – gvm."
keywords = ["go","version management"]
title = "Go versions, how to make updates easier"
categories = ["golang"]

+++

[Go](https://golang.org/) is an open source programming language that makes it easy to build simple, reliable, and efficient software.

Because of its rapid development, there is an issue with version updates.
It requires not only download and compile new version, but also update `$GOROOT` and `$GOPATH` environment variables.

One way to simplify this process is to use version manager, such as [gvm](https://github.com/moovweb/gvm).
Installations process is super easy:

```bash
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
```

To install proper version of Go use:

```bash
gvm install go1.6
```

As simple as that.
