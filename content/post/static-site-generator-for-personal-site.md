+++
categories = ["golang","hugo","static site"]
date = "2015-08-21T23:31:19+08:00"
description = "Hugo as personal site generator"
keywords = ["hugo","golang","static site"]
title = "Static site generator for personal page"

+++

Many of us would like to have personal identity in the Internet, write blog, share pictures, code and discuss interesting topics.
For tech related articles social networks would not be enought and we should look for personal blog or website solution.
Here I would like to explain some ideas behing my choice -- [hugo](https://gohugo.io), static site generator written in [Go](https://golang.org/).

First of all, let us write down requirements for personal page:

* It should work even if we dont have time to support it
* Custom domain support
* In case of blog, we should be able to add articles easily, deployment should not be problem

A while ago I had personal page stored on virtual machine in some cloud service.
It requires me to pay for VM and causes deployment difficulties.
I realized, that solution should be different.

WordPress offers good service, but price of custom domain makes use of it questionable.
My decision was to use static site generator and deploy it to GitHub.
I did not want to customise site a lot from the beginning, content is more important here.
Moreover, additional tools, such as Google Analytics and Discuss comes with framework.

There are [a lot of static site generators](https://www.staticgen.com/) on the market.
How to choose right?
My goal was to choose something simple, yet flexible to be able to use it in other projects as well.

First of all I checked python Pelican, because of my language knowledge.
It looks very similar to Django.
I did not really find it interesting and it's own website was a bit ugly.

Then I try to setup Assemble and found it not easy to work with.
Idea was to use technologies as close to frontend development as possible.
Another JavaScript tools I try were Metalsmith and Hexo.
They require their custom plugins for everything and I don't understand, why it is better than more generic plugins of Grunt or Gulp.

Next candidate was Jekyll.
