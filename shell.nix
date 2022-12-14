{  pkgs ? import <nixpkgs> {}, ... }:
let
  example_app = pkgs.python3.pkgs.buildPythonApplication rec {
    name   = "example_app";
    format = "pyproject";

    propagatedNativeBuildInputs = (with pkgs.python3.pythonForBuild.pkgs; [
      setuptools
      setuptools_scm
      wheel
    ]);

    src = ./.;

    doCheck = false;
  };
in
pkgs.mkShell {
  nativeBuildInputs = (with pkgs; [
    example_app
  ]);
}

