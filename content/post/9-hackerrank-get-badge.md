+++
categories = ["machine learning"]
date = "2016-09-27T08:06:30+08:00"
description = "HackerRank is a company that focuses on competitive programming challenges. To drive competition among the users, it gives medals and badges for achievements in domain competitions. This guide reveals how to get top 4-stars badge in machine learning."
keywords = ["HackerRank", "machine learning badge", "competitive programming"]
title = "From zero to four: how to get top machine learning badge on HackerRank"

+++

{{<img src="/images/hackerrank-for-dummies.png" alt="hacker rank for dummies">}}

[HackerRank](https://www.hackerrank.com/) is a company that focuses on competitive programming challenges. Compared to TopCoder or Codeforces it covers more software engineering areas, e.g. machine learning and functional programming. The company offers two types of challenges: contests and domain competitions. First requires to solve as many tasks as possible during given time frame, while second counts points for every solved problem regardless time. To drive competition among the users, HackerRank gives medals for good results in contests and [badges](https://www.hackerrank.com/scoring#badges-and-medals) for achievements in domain competitions.

There are three types of badges for each of the domains: Algorithms, Machine Learning and Functional Programming. Each badge could have from one to four stars: the more stars, the better. In addition to stars, HackerRank shows user rating as a percentile of overtaken competitors.

Based on my observation, Machine Learning is a second popular domain on the website. One could say, that the most well-known service to test skills in that area is [Kaggle](https://www.kaggle.com/). Compared to it HackerRank is focused more on software engineering tasks, which take from one day to two weeks to solve.

To a certain extent, Machine Learning domain is marketing driven. First of all, it is also called Artificial Intelligence. It consists of sub-domains with “buzz” names: “Bot Building”, “Natural Language Processing”, “Digital Image Analysis”, etc. Some of the sub-domains have a little to do with Machine Learning, e.g. “A* Search”, “Alpha Beta Pruning” and “Combinatorics”. Data Science is not there yet.

## Scoring system

As mentioned earlier, users could earn stars on their badges and rating towards higher percentile. I would split a journey into three phases illustrated below:

{{<img src="/images/hackerrank-phases.png" alt="machine learning badge phases">}}

During first phase a user should score at least 50 points each in each of the following sub-domains: “Bot Building” and “Statistics and Machine Learning”. In addition to that, there are should be 150 points in total. After this phase, a user would have a badge with one star on the profile page.

Second phase strategy is to increase the number of stars to the maximum. Each star is given for next 25% percentile group entering. One need to overtake 75% of users to receive four stars. It requires to score about 700 points. Interestingly, because of a large number of participants, a difference between one and two stars is minimal. Three solved problems could already make it.

It is not that hard to achieve a maximum level in Machine Learning domain. In fact, the whole game just starts after it. Now the only distinguishing factor is a rank and user’s percentile. I was able to [enter top 10%](https://www.hackerrank.com/pavlov99) in two weeks.

{{<img src="/images/hackerrank-proof.png" alt="hacker rank proof">}}

## How To

To earn the first star one need to get 50 points in “Bot Building” and “Statistics and Machine Learning” sub-domains.

First four tasks from “Bot Building” give you 57 points. Later tasks do not have a perfect solution and require heuristics implementation and [memory simulation](https://www.hackerrank.com/environment/writing-to-file).

“Statistics and Machine Learning” has a bunch of correlation tasks, which could be solved with [Wolfram Alpha](https://www.wolframalpha.com/) and relatively easy regression tasks. Note, that some of the solutions would work with different tasks, so one could earn points without coding. Get just enough points here and move on. There are easier sub-domains remain untouched.

Once both required areas are covered, it is easier to **solve problems by categories**. Reuse as much code as possible and write as less as possible. I recommend to go for “Probability and Statistics” sub-domain first and solve everything there.

My next choice was “Natural Language Processing”. Python’s package nltk works well here. Note, to get maximum points in minimal time frame you don’t need to actually program solution. [Some tasks](https://www.hackerrank.com/challenges/nlp-pos-tagging-2) have only several possible answers, so try them one by one.

Be aware of tricks and always read Discussions and Editorial if available. Even if a task is simple, user community might help with techniques to apply in more complicated versions. Ironically, some people “hacked” HackerRank and [scored 80 points out of 40 possible](https://www.hackerrank.com/challenges/from-paragraphs-to-sentences/leaderboard) in one of the tasks.

These steps allowed to receive four stars and even make it to 90% percentile. I believe that the game only begins and there are more challenges to solve, however, gamification part of the journey is already ended.

In addition to this advice, I recommend to **choose a proper programming language** for every task (check available [libraries](https://www.hackerrank.com/environment)) and **store your code in a repository**. If you forget any previous solution it is always easy to figure it with existing code. Last, but not the least, think out of the box!

## Conclusion

HackerRank offers a variety of software engineering challenges. Most of them are similar to real life applications (including wrong spec description), therefore it serves the purpose. Do not go there to solve research problems.

It is fairly easy to get a four-stars badge there because of low activity of existing users, but the game only starts from there.

