+++
categories = ["golang","hugo","static site"]
date = "2015-08-22T23:31:19+08:00"
description = "Hugo as personal site generator"
keywords = ["hugo","golang","static site"]
title = "Static site generator for personal blog"
+++

Many of us would like to have personal identity in the Internet, write blog, share pictures, code and discuss interesting topics.
For tech related articles social networks would not be enought and we should look for personal blog or website solution.
Here I would like to explain some ideas behing my choice -- [hugo](https://gohugo.io), static site generator written in [Go](https://golang.org/).

First of all, let us write down requirements for personal page:

* Web site should work even if we dont have time to support it
* It should support custom domains
* In case of blog, we should be able to add articles easily and deployment should not be problem

A while ago I had personal page, stored on virtual machine in some cloud service.
This requires me to pay for VM and causes deployment difficulties.
I realized, that solution should be different.

WordPress offers good service, but price of custom domain makes use of it questionable.
My decision was to use static site generator and deploy it to GitHub, because it is free.
I did not want to customise site a lot from the beginning, content is more important at that period.
Moreover, additional tools, such as Google Analytics and Discus comes with framework.

There are [a lot of static site generators](https://www.staticgen.com/) on the market.
How to choose right one?
My goal was to choose something simple, yet flexible to be able to use it in other projects as well.

First of all I checked python Pelican, because of my language knowledge.
It looks very similar to Django.
I did not really find it interesting and it's own website was a bit ugly.

Next, I try JavaScript based generators.
From my point of view, technology itself should be as close to frontend development as possible.
For example, I would rather go for JavaScript instead of Ruby.
I was not able to setup Assemble in 20-30 minutes and found it not easy to work with.
Another JavaScript tools I try were Metalsmith and Hexo.
They require their custom plugins for everything and I don't understand, why it is better than more generic plugins of Grunt or Gulp.

Next candidate was Jekyll.
It has at least twice as more GitHub stars, than second popular solution.
It is also default GitHub pages solution.
Frankly speaking, Jekyll looks good, but a bit big, so it might be difficult to write own plugins.
At that point of time, I wanted to avoid Ruby and try something else.

My final choice was Hugo.
It is program, written in Golang, which provides functionality to create, develop and build static website.
As advantages I would like to mention:

* Blazing fast build time (under 0.1 sec)
* Tag support: it generates search result pages for every tag used
* It has not only blog support, user could create any page with any url
* Google Analytics, Discuss, Gravatar, Social integration come out of the box

During development I use *develop* branch for source code.
Hugo builds statis pages in *public* folder, which is pushed to master branch using git-subtree.
You could read about this technique [here](http://gohugo.io/tutorials/github-pages-blog/#configure-git-workflow).
To simplify deployment, there is Makefile command with following code:

{{< highlight bash >}}
hugo
git add -A
git commit -m "rebuilding site '$(shell date)'"
git push origin develop
git subtree push --prefix=public git@github.com:pavlov99/pavlov99.github.com.git master
{{< /highlight >}}


I would like to recommend Hugo for anybody, who wants to build static pages.
