---
title: "Intro to REST APIs: Part 1"
date: 2017-07-10T20:46:29-07:00
---

## When it comes to writing software

I'm more comfortable calculating the RMS of an array of PCM samples or implementing a variable delay ringbuffer.

There are exciting technologies out there (that are commonplace to most developers) that I have yet to deal with in my worklife.  RESTful APIs are one of those technologies.  To have a wealth of information only an HTTP request away is exciting but it's not the thing that comes up often when building an audio system.

In order to get more familiar with how these APIs work I undertook a small project; I'd automate one of my methods for discovering new music through Spotify.

This will be a series of posts talking about how I did just that.

## How I discover music

[Metacritic](metacritic.com) is a great site for discovering new music.  It aggregates reviews from many respected media reviewing sites and displays the results for users.  I like to refer to it as the Rotten Tomatoes of TV, movies, music, and games.

Every couple of weeks I would navigate to the new releases section of metacritic and look for highly rated albums.  I'd throw these albums into a playlist and then listen to them while at work.  It's been a great way to discover music that I would've dismissed as a recommendation from a friend or stranger.

## Automating it

Replacing my manual method of curating playlists could be broken down into 3 steps:

  1. Scrape Metacritic to find new/"good" albums
  2. Interact with Spotify's API to add these albums to a playlist
  3. Run the script weekly to make sure the playlist stayed fresh

In the following posts I'll break down how I solved each of these subproblems and the things I learned along the way.

## Wrap-Up

In [part 2](/post/intro_to_apis/scraping_metacritic) I'll talk about how I scraped the information from Metacritic.
