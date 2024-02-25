defmodule DievergoldereiWeb.PostView do
  use DievergoldereiWeb, :html

  embed_templates "../templates/post/*"

  def month_link(%Date{month: month, year: year}, opts \\ []) do
    text = Dievergolderei.DateUtil.month_name(month) <> " #{year}"
    link = "#{year}-#{month}"

    opts = Keyword.merge(opts, to: ~p"/blog/#{link}")

    link(text, opts)
  end
end
