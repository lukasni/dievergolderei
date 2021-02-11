defmodule Dievergolderei.Sanitizer.Scrubber do
  @moduledoc """
  Custom HTML scrubber definition to allow some tags not covered by any of the defaults
  """
  require HtmlSanitizeEx.Scrubber.Meta
  alias HtmlSanitizeEx.Scrubber.Meta

  @valid_schemes ["http", "https", "mailto", "tel"]

  Meta.remove_cdata_sections_before_scrub()
  Meta.strip_comments()

  Meta.allow_tag_with_uri_attributes("a", ["href"], @valid_schemes)
  Meta.allow_tag_with_these_attributes("a", ["name", "title"])
  Meta.allow_tag_with_this_attribute_values("a", "target", ["_blank"])
  Meta.allow_tag_with_this_attribute_values("a", "rel", ["noopener", "noreferrer"])
  Meta.allow_tag_with_these_attributes("address", ["class"])
  Meta.allow_tag_with_these_attributes("blockquote", ["cite"])
  Meta.allow_tag_with_these_attributes("br", [])
  Meta.allow_tag_with_these_attributes("code", ["class"])
  Meta.allow_tag_with_these_attributes("del", ["cite", "datetime"])
  Meta.allow_tag_with_these_attributes("div", ["class", "style"])
  Meta.allow_tag_with_these_attributes("em", [])
  Meta.allow_tag_with_these_attributes("h1", [])
  Meta.allow_tag_with_these_attributes("h2", [])
  Meta.allow_tag_with_these_attributes("h3", [])
  Meta.allow_tag_with_these_attributes("h4", [])
  Meta.allow_tag_with_these_attributes("h5", [])
  Meta.allow_tag_with_these_attributes("h6", [])
  Meta.allow_tag_with_these_attributes("hr", [])
  Meta.allow_tag_with_uri_attributes("img", ["src"], @valid_schemes)
  Meta.allow_tag_with_these_attributes("img", ["width", "height", "alt", "title"])
  Meta.allow_tag_with_these_attributes("ins", ["cite", "datetime"])
  Meta.allow_tag_with_these_attributes("li", [])
  Meta.allow_tag_with_these_attributes("ol", [])
  Meta.allow_tag_with_these_attributes("p", [])
  Meta.allow_tag_with_these_attributes("pre", [])
  Meta.allow_tag_with_these_attributes("span", ["class", "style"])
  Meta.allow_tag_with_these_attributes("strong", [])
  Meta.allow_tag_with_these_attributes("table", [])
  Meta.allow_tag_with_these_attributes("tbody", [])
  Meta.allow_tag_with_these_attributes("td", [])
  Meta.allow_tag_with_these_attributes("th", [])
  Meta.allow_tag_with_these_attributes("thead", [])
  Meta.allow_tag_with_these_attributes("tr", [])
  Meta.allow_tag_with_these_attributes("ul", [])

  Meta.strip_everything_not_covered()
end
