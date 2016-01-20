module Jekyll
  class TranscriptParser
    attr_reader :parsed

    def initialize(config, markdown_converter = nil)
      @config = config
      @markdown_converter = markdown_converter || Converters::Markdown.new(config)
    end

    def parse(text)
      @parsed = []
      text.each_line do |line|
        line = line.strip
        if line[0..1] == '!#'
          speaker, timestamp = line[2..-1].strip.split('@').map(&:strip)
          @parsed << {speaker: speaker, timestamp: timestamp, comments: ''}
        else
          next if (@parsed.empty? || @parsed.last[:comments].empty?) and line.empty? #don't prepend empty line to comment
          @parsed << {comments: ''} if @parsed.empty?
          @parsed.last[:comments] << line + "\n"
        end
      end
      self
    end

    def to_html (speakers_meta = nil)
      speakers = [] #track speakers seen to track which side to display picture
      "<div class='conversation-wrapper'>" +
      @parsed.map.with_index do |p, i|
        return @markdown_converter.convert(p[:comments] || '') if p[:speaker].nil?
        speakers << p[:speaker] unless speakers.include?(p[:speaker])
        display_image_on_right = speakers.find_index(p[:speaker]).odd?
        speaker_meta = (speakers_meta || []).find { |s| s['name'] == p[:speaker]}
        %{
          <div class='speaker #{display_image_on_right ? 'speaker-right' : 'speaker-left'}' style='order: #{display_image_on_right ? i + 1 : i}'> 
            <img src='#{ speaker_image_url(speaker_meta) }' />
            #{@markdown_converter.convert((p[:speaker] || '') + (p[:timestamp] ? ' @ ' + p[:timestamp] : ''))}
          </div>
          <div class='blurb-wrapper' style='order: #{display_image_on_right ? i : i + 1}'>
            <div class='blurb #{display_image_on_right ? 'blurb-right' : 'blurb-left'}'>
              #{@markdown_converter.convert(p[:comments] || '')}
            </div>
          </div>
        }
      end.join +
      "</div>"
    end

    private
    def speaker_image_url (speaker_meta)
      return "#{ @config['url'] }/images/generic_speaker.png" if speaker_meta.nil? or speaker_meta['image_url'].nil?
      speaker_meta['image_url']
    end
  end

  class TranscribeConverter < Converter
    def initialize(config)
      super(config)
      Jekyll::Hooks.register :posts, :pre_render do |post|
        @speakers_meta = post.data['speakers']
      end

      Jekyll::Hooks.register :posts, :post_render do |post|
          @speakers_meta = nil
      end
      @parser = TranscriptParser.new(config)
    end
    def matches(ext)
      ext == ".transcript"
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      @parser.parse(content).to_html(@speakers_meta)
    end
  end
end
