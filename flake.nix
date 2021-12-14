{
  description = "A flake for building Hello World";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; }; {
      myhello = stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildPhase = "gcc -o hello ./hello.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
        outputHashMode = "recursive";
        outputHash = "sha256-T19Hhg7VPVIea8piV4S5g+Budc5sjSN1sy2weEnMXDY=";
      };

      myhello-wrapped = runCommandNoCC "hello" {} ''
        mkdir -p $out/bin
        cp ${self.packages.x86_64-linux.myhello}/bin/hello $out/bin
      '';
    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.myhello-wrapped;

  };
}
