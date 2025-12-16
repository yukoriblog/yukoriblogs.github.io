require 'rss'
require 'open-uri'
require 'fileutils'

rss_url = 'https://feed.luoquant.com/ai'   # free, no auth
feed    = RSS::Parser.parse(URI.open(rss_url).read, false)

Dir.mkdir('_posts') unless Dir.exist?('_posts')

feed.items.first(100).each do |item|
  date = item.pubDate.strftime('%Y-%m-%d')
  slug = item.title.downcase.gsub(/[^a-z0-9]+/i, '-')[0..80]
  path = "_posts/#{date}-#{slug}.md"
  next if File.exist?(path)

  File.write(path, <<~FRONT)
    ---
    layout: post
    title: "#{item.title.gsub('"','\"')}"
    tags: ai-tool
    ---
    #{item.description}

    <!-- adsense after para 2 -->
    {%- include inject_ads.html %}
  FRONT
end
