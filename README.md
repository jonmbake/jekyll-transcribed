# jekyll-transcribed

A [Jekyll](http://jekyllrb.com/) plugin for generating conversational transcripts.

## In A Nutshell

Takes this:

```
---
layout: post
title: An Example Transcript
speakers:
  - name: 'Jon'
    image_url: 'https://avatars1.githubusercontent.com/u/865534'
---

!# Jon @ 0:00
**Wow!** This is *really* cool.  Now I can transcribe all my conversations easily for everyone to see.

It even supports [Markdown](markdown) so I can easily transcribe links, lists

...
```
*_plugins/2016-01-19-example.transcript*

And generates this:

![Transcript Output](https://raw.githubusercontent.com/jonmbake/screenshots/master/jekyll-transcribed/convo.png)

## Installation

Copy over the following assets to your [Jekyll](http://jekyllrb.com/) install:

1. `_plugins/transcript_converter.rb` to your `_plugins` directory
2. `css/transcripts.css` to your `css` directory
3. `images/generic_speaker.png` to your `images` directory

You also need to update `_includes/head.html` to include the `transcript.css`:

```
<link rel="stylesheet" href="{{ "/css/transcripts.css" | prepend: site.baseurl }}">
```

## Creating a Conversational Transcript

Transcripts must be placed in `_posts` and have a `.transcript` extension.

Transcripts are an extension of [Markdown](https://daringfireball.net/projects/markdown/).  It simply adds the *bang-hash* (!#) element to the *Markdown* lexicon. The new element defines the start of a speaker's comments.  Contents of the *bang-hash* should contain the speakers name and an optional time stamp.  Everything else is processed as markdown.

### YAML Front Matter

You can also include front matter to specify image URLs to use.  See example above on how this is done.

