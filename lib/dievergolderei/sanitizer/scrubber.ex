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
  Meta.allow_tag_with_these_attributes("a", ["name", "title", "class"])
  Meta.allow_tag_with_this_attribute_values("a", "target", ["_blank"])
  Meta.allow_tag_with_this_attribute_values("a", "rel", ["noopener", "noreferrer"])
  Meta.allow_tag_with_these_attributes("address", ["class"])
  Meta.allow_tag_with_these_attributes("blockquote", ["cite", "class"])
  Meta.allow_tag_with_these_attributes("br", [])
  Meta.allow_tag_with_these_attributes("code", ["class"])
  Meta.allow_tag_with_these_attributes("del", ["cite", "datetime"])
  Meta.allow_tag_with_these_attributes("div", ["class", "style"])
  Meta.allow_tag_with_these_attributes("em", ["class"])
  Meta.allow_tag_with_these_attributes("h1", ["class"])
  Meta.allow_tag_with_these_attributes("h2", ["class"])
  Meta.allow_tag_with_these_attributes("h3", ["class"])
  Meta.allow_tag_with_these_attributes("h4", ["class"])
  Meta.allow_tag_with_these_attributes("h5", ["class"])
  Meta.allow_tag_with_these_attributes("h6", ["class"])
  Meta.allow_tag_with_these_attributes("hr", ["class"])
  Meta.allow_tag_with_uri_attributes("img", ["src"], @valid_schemes)
  Meta.allow_tag_with_these_attributes("img", ["width", "height", "alt", "title", "class"])
  Meta.allow_tag_with_these_attributes("ins", ["cite", "datetime"])
  Meta.allow_tag_with_these_attributes("li", ["class"])
  Meta.allow_tag_with_these_attributes("ol", ["class"])
  Meta.allow_tag_with_these_attributes("p", ["class"])
  Meta.allow_tag_with_these_attributes("pre", ["class"])
  Meta.allow_tag_with_these_attributes("span", ["class", "style"])
  Meta.allow_tag_with_these_attributes("strong", ["class"])
  Meta.allow_tag_with_these_attributes("table", ["class"])
  Meta.allow_tag_with_these_attributes("tbody", ["class"])
  Meta.allow_tag_with_these_attributes("td", ["class"])
  Meta.allow_tag_with_these_attributes("th", ["class"])
  Meta.allow_tag_with_these_attributes("thead", ["class"])
  Meta.allow_tag_with_these_attributes("tr", ["class"])
  Meta.allow_tag_with_these_attributes("ul", ["class"])

  Meta.strip_everything_not_covered()
end
