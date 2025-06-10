{ pkgs, inputs, config, ... }:
{
	
	stylix = {
	
		enable = true;

		autoEnable = true;

		polarity = "dark";

		base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
		targets = {
        gnome.enable = false;
        qt.enable = false;
      };

#		cursor = {
#			name = "graphite-dark-nord";
#			package = pkgs.graphite-cursors;
#			size = 24;
#		};

		fonts = {
			monospace = {
      package = pkgs.nerd-fonts.fira-mono;
      name = "Fira Mono Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.fira-mono;
         name = "Fira Mono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.fira-mono;
        name = "Fira Mono Nerd Font";
      };
		};
	};
}
