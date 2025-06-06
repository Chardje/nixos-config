{ pkgs, inputs, config, ... }:
{

	stylix = {
	
		enable = true;

		autoEnable = true;

		polarity = "dark";

		base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
		

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
		    serif = config.stylix.fonts.monospace;
		    sansSerif = config.stylix.fonts.monospace;
		    #emoji = config.stylix.fonts.monospace;
		  };
		
	};
}
