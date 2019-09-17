defmodule DievergoldereiWeb.PostView do
  use DievergoldereiWeb, :view

  def month_link(conn, %Date{month: month, year: year}) do
    text = Dievergolderei.Util.month_name(month) <> " #{year}"
    link = "#{year}-#{month}"
    Phoenix.HTML.Link.link(text, to: Routes.post_path(conn, :list, link))
  end
end
