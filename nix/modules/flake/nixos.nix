{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.default = ../nixos;

    nixosConfigurations.bastion =
      let
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;

        # Decrypt sops secrets at build time (no runtime service)
        ageKeyFile =
          if (builtins.getEnv "SOPS_AGE_KEY_FILE" != "") then
            builtins.getEnv "SOPS_AGE_KEY_FILE"
          else
            (builtins.getEnv "HOME" + "/.config/sops/age/keys.txt");
        ageKeyContent = builtins.readFile ageKeyFile;
        secretsJson =
          pkgs.runCommand "secrets-json"
            {
              nativeBuildInputs = [ pkgs.sops ];
              SOPS_AGE_KEY = ageKeyContent;
            }
            ''
              sops --decrypt --output-type json ${../../secrets.sops.yaml} > $out
            '';
        secrets = builtins.fromJSON (builtins.readFile secretsJson);
      in
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          inputs.home-manager.nixosModules.home-manager
          ../../hosts/linux/bastion
          self.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit self inputs unstablePkgs;
                bastion_host = secrets.bastion_host;
              };
              backupFileExtension = "backup";
              users.gwelican.imports = [ self.homeModules.gwelican ];
            };

            nixpkgs.config.allowUnfree = true;
          }
        ];

        specialArgs = { inherit self inputs unstablePkgs; };
      };
  };
}
