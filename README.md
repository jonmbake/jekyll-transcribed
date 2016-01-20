# jekyll-transcribed

A [Jekyll](http://jekyllrb.com/) plugin for generating conversational transcripts.

## [Demo of a Generated Page](http://jonmbake.github.io/jekyll-transcribed/2016/01/19/example.html)

## How It Works

Converts posts with a `.transcript` extension from this [2016-01-19-example.transcript](https://github.com/jonmbake/jekyll-transcribed/blob/master/_posts/2016-01-19-example.transcript) to this [Generated Transcript Page](http://jonmbake.github.io/jekyll-transcribed/2016/01/19/example.html).

## Installation

Copy over the following assets to your [Jekyll](http://jekyllrb.com/) install:

1. `_plugins/transcript_converter.rb` to your `_plugins` directory
2. `css/transcripts.css` to your `css` directory
3. `images/generic_speaker.png` to your `images` directory

You also need to update `_includes/head.html` to include the `transcript.css`:

```
<link rel="stylesheet" href="{{ "/css/transcripts.css" | prepend: site.baseurl }}">
```

## Creating a Transcript

Transcripts must be placed in `_posts` and have a `.transcript` extension.

Transcripts are an extension of [Markdown](https://daringfireball.net/projects/markdown/).  It simply adds the *bang-hash* (!#) element to the *Markdown* lexicon. The new element defines the start of a speaker's comments.  Contents of the *bang-hash* should contain the speakers name and an optional time stamp.  Everything else is processed as markdown.

### YAML Front Matter

You can also include front matter properties to specify image URLs to use for each speakers.  See example above on how this is done.

