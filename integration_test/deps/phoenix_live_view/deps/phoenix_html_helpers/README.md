# PhoenixHTMLHelpers

[![Build Status](https://github.com/phoenixframework/phoenix_html_helpers/workflows/Tests/badge.svg)](https://github.com/phoenixframework/phoenix_html_helpers/actions?query=workflow%3ATests)

Collection of helpers to generate and manipulate HTML contents.
These helpers were used in Phoenix v1.6 and earlier versions,
before the introduction of `Phoenix.Component`.

To maintain compatibility, replace `use Phoenix.HTML` in your applications by:

```elixir
import Phoenix.HTML
import Phoenix.HTML.Form
use PhoenixHTMLHelpers
```

See the [docs](https://hexdocs.pm/phoenix_html_helpers/) for more information.

This library is maintained for compatibility, but does not accept new features.

## License

Copyright (c) 2014 Chris McCord

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
