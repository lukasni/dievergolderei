defmodule Dievergolderei.SanitizeTest do
  use ExUnit.Case

  defp sanitize(text) do
    text |> Dievergolderei.Sanitizer.sanitize()
  end

  test "allows basic formatting tags" do
    input =
      "<h1>Title</h1>\n<p>Paragraph with <em>emphasized</em> and <strong>strongly emphasized</strong> text</p>"

    expected = input

    assert expected == sanitize(input)
  end

  test "allow local links" do
    input = ~s(<a href="/impressionen">Link</a>)
    expected = input

    assert expected == sanitize(input)
  end

  test "allow http and https links" do
    input = ~s(<a href="http://example.com">Insecure</a><a href="https://example.com">Secure</a>)
    expected = input

    assert expected == sanitize(input)
  end

  test "allow link with valid target" do
    input = ~s(<a href="#" target="_blank">Link</a>)
    expected = input

    assert expected == sanitize(input)
  end

  test "strip invalid target from link" do
    input = ~s(<a href="#" target="other">Link</a>)
    expected = ~s(<a href="#">Link</a>)

    assert expected == sanitize(input)
  end

  test "allow noopener in links" do
    input = ~s(<a href="#" rel="noopener">Link</a>)
    expected = input

    assert expected == sanitize(input)
  end

  test "allow noreferrer in links" do
    input = ~s(<a href="#" rel="noreferrer">Link</a>)
    expected = input

    assert expected == sanitize(input)
  end

  test "strip other rels in links" do
    input = ~s(<a href="#" rel="tag">Link</a>)
    expected = ~s(<a href="#">Link</a>)

    assert expected == sanitize(input)
  end

  test "allow call and mail links" do
    input = ~s(<a href="tel:+15556782345">Call</a><a href="mailto:email@example.com">Mail</a>)
    expected = input

    assert expected == sanitize(input)
  end

  test "allow local images" do
    input =
      ~s(<img src="/photos/3" width="300" height="150" alt="Image description" title="Image title" />)

    expected = input

    assert expected == sanitize(input)
  end

  test "allow http and https images" do
    input =
      ~s(<img src="http://example.com/insecure.png" /><img src="https://example.com/secure.png" />)

    expected = input

    assert expected == sanitize(input)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"

    expected = "code!<p>hello code!</p>"
    assert expected == sanitize(input)
  end

  test "strips tags with comment" do
    input = "This has a <!-- comment --> here."
    expected = "This has a  here."
    assert expected == sanitize(input)
  end

  test "strip_tags escapes special characters" do
    assert "&amp;", sanitize("&")
  end

  test "allow language class in code tag" do
    input = ~s[<code class="elixir">String.split("Two words")</code>]
    expected = input

    assert expected == sanitize(input)
  end

  test "allow del and ins tags with cite and date" do
    input = """
    <del cite="/explanation.html" datetime="2019-07-08T14:55:21Z">Deleted</del>
    <ins cite="/explanation.html" datetime="2019-07-08T15:02:12Z">Inserted</ins>
    """

    expected = input

    assert expected == sanitize(input)
  end

  test "allow div and span with custom styling" do
    input = """
    <div style="padding: 2rem"><span class="mb-0">Text</span><br />
    <span style="text-decoration: underline">More text</span>
    </div>
    """

    expected = input

    assert expected == sanitize(input)
  end

  test "allow all allowed tags" do
    input = """
    <pre>This is preformatted text</pre>
    <address>This is an address</address>
    <blockquote cite="source.html">This is a quote</blockquote>
    <h1>Heading 1</h1>
    <h2>Heading 2</h2>
    <h3>Heading 3</h3>
    <h4>Heading 4</h4>
    <h5>Heading 5</h5>
    <h6>Heading 6</h6>
    <hr />
    <ul><li>Unordered list</li></ul>
    <ol><li>Ordered list</li></ol>
    <table>
    <thead><tr><th>Table heading</th></tr></thead>
    <tbody><tr><td>Table data</td></tr></tbody>
    </table>
    """

    expected = input

    assert expected == sanitize(input)
  end

  test "fix incomplete allowed tags" do
    input = "<p>This paragraph isn't closed"
    expected = "<p>This paragraph isn't closed</p>"

    assert expected == sanitize(input)
  end
end
