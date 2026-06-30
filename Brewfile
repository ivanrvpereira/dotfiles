# Compatibility wrapper for commands that still use `brew bundle --file Brewfile`.
# Bootstrap installs these files explicitly so CLI tools can succeed independently
# from GUI apps/casks.

instance_eval(File.read(File.expand_path("Brewfile.cli", __dir__)), File.expand_path("Brewfile.cli", __dir__))
instance_eval(File.read(File.expand_path("Brewfile.desktop", __dir__)), File.expand_path("Brewfile.desktop", __dir__))
