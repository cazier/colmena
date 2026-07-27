{
  lib,
  stdenv,
  writeShellScriptBin,
  cargo,
  clippy,
  deno,
  editorconfig-checker,
  git,
  nixfmt-tree,
  ruff,
  rustc,
  rustfmt,
  taplo,
}:

writeShellScriptBin "formatter" ''
  export PATH="${
    lib.makeBinPath [
      cargo
      clippy
      deno
      editorconfig-checker
      git
      nixfmt-tree
      ruff
      rustc
      rustfmt
      stdenv.cc
      taplo
    ]
  }"

  set -eoux pipefail
  shopt -s globstar

  pushd "$(git rev-parse --show-toplevel)" > /dev/null

  # disable this for now
  # deno fmt **/*.md **/*.{yml,yaml} **/*.js

  # also disabled for now (produce too maybe diffs)
  # ruff check --fix --unsafe-fixes --preview .

  treefmt .

  taplo format **/*.toml

  cargo-clippy --all-targets --all-features --fix --allow-dirty -- -D warnings
  cargo-fmt --all

  # must run last
  editorconfig-checker

  popd
''
