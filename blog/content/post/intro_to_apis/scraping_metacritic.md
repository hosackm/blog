+++
date = "2017-07-11T10:18:54-07:00"
title = "Intro to REST APIs: Part 2"
draft = true
+++

Check out [Part 1](/post/intro_to_apis/web_api_intro) for an introduction to what this post is all about.

# Scraping Reviews from Metacritic

Every week or so I navigate to Metacritic's [new releases page](http://www.metacritic.com/browse/albums/release-date/new-releases) to see what new music has recently come out.  If you look at the page it has a long table that lists an album's title, artist, ranking, and release date.  Metacritic is an aggregator of other sites' reviews of albums.  A high score on Metacritic is  a reliable indicator of it's quality.  If an album receives a score of 80 or higher I consider it something I should check out. (Albums receiving scores of less than 40 are also worth checking out but for completely different reasons)

In this post I'll talk about my method for turning Metacritic's new releases page into something we can work with in Python.  First I'll talk about how to identify relevant information from a page of HTML and then I'll show you how we can use some helpful libraries to parse out that information.


## Inspecting Metacritic's New Release Page


Let's see if we can find ways to pick out this information from the HTML from Metacritic.

If you're using Chrome you can right-click on the first item in the table (click the empty space in between the album title and the artist) and select Inspect.  We can look at the HTML that corresponds with the entry for a row in the new releases table. This will open up the *Elements* window.  From here we see an HTML tag like the following:

{{< highlight html >}}
<div class="product_wrap">
  <div class="basic_stat product_title">
    <a href="/music/album-title">
      A Fever Dream
    </a>
  </div>
    <div class="basic_stat product_score brief_metascore">
      <div class="metascore_w small release positive">
        78
      </div>
    </div>
    <div class="basic_stat condensed_stats">
      <ul class="more_stats">
        <li class="stat product_artist">
          <span class="label">
            Artist:
          </span>
          <span class="data">
            Everything Everything
          </span>
        </li>
        <li class="stat product_avguserscore">
          <span class="label">
            User:
          </span>
          <span class="data textscore textscore_tbd">
            73
          </span>
        </li>
        <li class="stat release_date">
          <span class="label">
            Release Date:
          </span>
          <span class="data">
            Aug 18
          </span>
        </li>
      </ul>
    </div>
  </div>
</div>
{{< /highlight >}}

The scraper is going to take this page and identify all the tags in the HTML it receives.  The first thing we want to do is figure out how we can reliably identify the following things:

  * the HTML tag that represents a new release
  * the HTML tag that represents the releases's score
  * the tag for the release's title
  * the tag for the release's artist
  * the tag for the release date

If we look at the attributes of each tag we see that the tags for the 5 criteria above all have different classes.  We can use these classes to extract the information for a release from a large tree of tags.

Here are the criteria we want and their relevant tag classes:

|criteria|tag class       |
|--------|----------------|
|release |*product_wrap*  |
|score   |*product_score* |
|title   |*product_title* |
|artist  |*product_artist*|
|date    |*release_date*  |

## Requesting the HTML in Python

In the previous section we inspected the HTML source in Chrome.  How do we get access to the same source in Python?

Python has built-in ways to make requests to websites but by far the easiest way to do this is to use the library [requests](https://github.com/kennethreitz/requests).

To install it type: `pip install requests`

Now we can get the source HTML from Metacritic by typing the following in the REPL:

{{< highlight python >}}

>>> import requests
>>> response = requests.get(
...    "http://www.metacritic.com/browse/albums/release-date/new-releases",
...    headers={"User-Agent": "python-script"})

{{< /highlight >}}

*On most websites you can leave off the headers argument, however Metacritic won't give you the actual content unless you supply a User-Agent with your request.*

The requests library will make an HTTP GET request to the url we provide and it will return to us an object that represents the server's reponse to us. If we look at the `content` attribute of the response we'll see the same HTML that we saw when we inspected the HTML in Chrome.

## Parsing the Response with BeautifulSoup

While Python makes it possible to parse the response from Metacritic as a string there are easier ways to extract the information we need.

[Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/) is a library that will take HTML and turn it into a special Python object.  This object can be used to search for certain tags and classes like the ones we identified in one of the previous sections.

Install it by typing: `pip install BeautifulSoup4`

We can have BeautifulSoup parse Metacritic's source by typing:
    
{{< highlight python >}}

>>> from bs4 import BeautifulSoup
>>> soup = BeautifulSoup(response.content, "html.parser")

{{< /highlight >}}

Now that we have a soup object we can search for tags within the HTML source.  For instance, the following would return a list of every link in the page:

{{< highlight python >}}
>>> soup.findAll("a")
{{< /highlight >}}

The `findAll` function has an optional second argument that will filter the results.  We can use this second argument to restrict the tags that are returned to ones that only have the class we want.

For example, here's how we'd find all the `div` elements that have `product_wrap` as a class:

{{< highlight python >}}
>>> releases = soup.findAll("div", {"class": "product_wrap"})
{{< /highlight >}}

The code above will actually return a list of every release on the Metacritic's new releases page.  Pretty useful for what we're doing.

It's worth noting that `findAll` return BeautifulSoup objects so for each of the objects returned in the previous code snippet we can invoke the method `findAll` again. So, if we wanted to find the score of the first release on the page we could type:

{{< highlight python >}}
>>> first = releases[0]
>>> score = first.find("div", {"class": "product_score"})
{{< /highlight >}}

*`find` is similar to `findAll` except it will return after finding the first tag that matches the tag type.*

## Wrap Up

Now we have all the tools we need to collect the HTML from Metacritic and convert it into values that we can use in Python.  I've only shown you how to gather the score for each release but gathering the other criteria I identified earlier is not much harder.

In the next post I'll show you how I used [Spotify's API](https://developer.spotify.com/web-api/) to create playlists for each of the albums on Metacritic.
