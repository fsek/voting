# frozen_string_literal: true

module MarkdownHelper
  require 'redcarpet/render_strip'
  def markdown(text)
    sanitize(markdown_renderer.render(text)) if text.present?
  end

  def sanitize(input)
    ActionView::Base.new.sanitize(input.html_safe) if input.present?
  end

  def markdown_renderer
    Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            no_intra_emphasis: true,
                            fenced_code_blocks: true,
                            autolink: true,
                            tables: true,
                            underline: true,
                            highlight: true)
  end
end
