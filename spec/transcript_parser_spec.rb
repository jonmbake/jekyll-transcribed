require 'spec_helper'
require 'nokogiri'
require 'jekyll'

load '_plugins/transcript_converter.rb'

describe Jekyll::TranscriptParser do
	before(:all) do
		@config = {
			'markdown'      => 'kramdown',
      'highlighter'   => 'rouge',
      'kramdown' => {},
      'lsi'           => false,
      'excerpt_separator' => "\n\n",
      'incremental'   => false
    }
		@parser = Jekyll::TranscriptParser.new(@config)
		@transcript = %{

			!# Jon @ 0:00
			What up, Bill?

			How are you doing?

			!# Bill @ 0:10
			I am doing pretty well.
			How about you?
		}
	end
	it 'will parse example' do
		@parser.parse(@transcript)
		expect(@parser.parsed).to match_array([{speaker: "Jon", timestamp: "0:00", comments: "What up, Bill?\n\nHow are you doing?\n\n"}, {speaker: "Bill", timestamp: "0:10", comments: "I am doing pretty well.\nHow about you?\n\n"}])
	end

	it 'will call Markdown converter on name and commments' do
		markdown_converter = Jekyll::Converters::Markdown.new(@config)
		parser = Jekyll::TranscriptParser.new(@config, markdown_converter)
		allow(markdown_converter).to receive(:convert)
		expect(markdown_converter).to receive(:convert).with('Jon @ 0:00')
		expect(markdown_converter).to receive(:convert).with("Some comments.\n")
		parser.parse("!# Jon @ 0:00\n\nSome comments.").to_html
	end

	it 'will generate the correct HTML' do
		speakers_meta = [{'name' => 'Jon', 'image_url' => 'images/my_pic.png'}]
		html = Nokogiri::HTML(@parser.parse(@transcript).to_html(speakers_meta))
		# side imsages/names
		expect(html.at_css('div.speaker-left > img').get_attribute('src')).to eq("images/my_pic.png")
		expect(html.at_css('div.speaker-left > p').text).to eq("Jon @ 0:00")
		expect(html.at_css('div.speaker-right > img').get_attribute('src')).to eq("/images/generic_speaker.png")
		expect(html.at_css('div.speaker-right > p').text).to eq("Bill @ 0:10")
		#comment
		expect(html.at_css('div.blurb-left > p:nth(1)').text).to eq("What up, Bill?")
		expect(html.at_css('div.blurb-left > p:nth(2)').text).to eq("How are you doing?")
		expect(html.at_css('div.blurb-right > p:nth(1)').text).to eq("I am doing pretty well.\nHow about you?")
		expect(html.at_css('div.blurb-right > p:nth(2)')).to be_nil
		#p html.at_css('div.blurb-left > p').methods
		#expect(left.get_attribute('style'))
		#p html.methods
		#p html.elements
		#p html.element_children
	end
end
