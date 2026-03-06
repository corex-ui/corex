File.rm_rf!("installer/corex_design")

shell! = fn command, opts ->
  {_, 0} =
    System.shell(
      command,
      Keyword.merge(
        [
          into: IO.binstream(:stdio, :line),
          stderr_to_stdout: true
        ],
        opts
      )
    )
end

shell_in_daisy! = fn command -> shell!.(command, cd: Path.expand("corex_design")) end

File.cd!("installer", fn ->
  shell!.("mix corex.new corex_design --dev --database sqlite3 --install", [])

  shell_in_daisy!.("mix corex.gen.auth Accounts User users --live")
  shell_in_daisy!.("mix deps.get")
  shell_in_daisy!.("mix corex.gen.live Blog Post posts title:string body:text")
  shell_in_daisy!.("mix tailwind corex_design")

  content = File.read!("corex_design/priv/static/assets/css/app.css")

  File.write!("templates/corex_static/default.css", """
  /* These are Corex styles for styling the default generator files
   * included to prevent shipping a completely unstyled page, even as you selected --no-design.
   * You can safely remove the whole file and all references to "default.css".
   */
  #{content}
  """)
end)

File.rm_rf!("installer/corex_design")
