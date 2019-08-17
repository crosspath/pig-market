abstract class BaseComponent
  include Lucky::HTMLBuilder

  needs view : IO::Memory

  # TODO: WTF is this? See lib/lucky/src/lucky/html_builder.cr:26:16
  def view; end
end
