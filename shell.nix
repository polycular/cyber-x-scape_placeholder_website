{ pkgs ? import <nixpkgs> {} }:

let
devserver = pkgs.rustPlatform.buildRustPackage rec {
  pname = "devserver";
  version = "0.4.0";

  src = pkgs.fetchCrate {
    inherit pname version;
    # sha256 = pkgs.lib.fakeSha256;
    sha256 = "1kp8c7ksxcmg49wkfp3w0gmi2ysd2dclnk6lm0rmvhhbq37cpjji";
  };

  # cargoSha256 = pkgs.lib.fakeSha256;
  cargoSha256 = "16zcp5wwh8w1ai1vqd4hahqiglqnpjvkb7pnpprnjyg35gld0njy";

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ openssl ];
};

base_hook = ''
  # short default prompt
  export PS1='\e[0;32m[nix-shell@\h] \W>\e[m '
'';
devserver_start = ''
  devserver --path web
'';
hooks = base_hook + devserver_start;
in
pkgs.mkShell {
  buildInputs = [
    devserver
  ];
  shellHook = hooks;
}
