{ pkgs, ...}:
{
programs.firefox = {
  enable = true;
  profiles = {
          profile_0 = {           
            id = 0;
            name = "Main";
            isDefault = true;
            settings = {
            };
            userChrome = ''
            
            #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
              opacity: 0;
              pointer-events: none;
            }
            
            #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
                visibility: collapse !important;
            }
            #tabbrowser-tabs { 
              visibility: collapse !important;
            }
            
            #sidebar-header {
              visibility: collapse !important;
            }

			/* Clean and tight extensions menu */
			#unified-extensions-panel #unified-extensions-view {
			  width: 100% !important; /* For Firefox v115.x */
			}
			
			#unified-extensions-view {
			  --uei-icon-size: 24px; /* Change icon size */
			  --firefoxcss-number-of-extensions-in-a-row: 4; /* Number of icons in one row */
			}
			
			/* Hide unnecessary elements */
			#unified-extensions-view .panel-header,
			#unified-extensions-view .panel-header + toolbarseparator,
			#unified-extensions-view .panel-subview-body + toolbarseparator,
			#unified-extensions-view .unified-extensions-item-menu-button.subviewbutton,
			#unified-extensions-view .unified-extensions-item-action-button .unified-extensions-item-contents {
			  display: none !important;
			}
			
			/* Manage extensions button visibility */
			@media -moz-pref("mod.hide.manage-extensions.button") {
			  #unified-extensions-view #unified-extensions-manage-extensions {
			    display: none !important;
			  }
			}
			
			/* Adjust manage extensions button appearance */
			@media not -moz-pref("mod.hide.manage-extensions.button") {
			  #unified-extensions-manage-extensions > .toolbarbutton-text {
			    display: none !important;
			  }
			
			  #unified-extensions-manage-extensions::after {
			    content: "";
			    display: block;
			    height: 2px; /* Thickness of your line */
			    width: 50%; /* Adjust as needed */
			    margin: auto;
			    background-color: light-dark(black, white); /* Auto adapted color */
			    border-radius: 6px; /* Rounded ends */
			    transition: width 0.15s ease 0.2s, opacity 0.15s ease 0.2s; /* Delay before expanding */
			    opacity: 0.2;
			  }
			
			  #unified-extensions-manage-extensions:hover::after {
			    width: 80%;
			    transition: width 0.15s ease 0s, opacity 0.15s ease 0s; /* No delay when hovering */
			    opacity: 0.6;
			  }
			
			  #unified-extensions-manage-extensions:not(:hover)::after {
			    width: 60%;
			    transition: width 0.15s ease 0.15s, opacity 0.15s ease 0.15s; /* Delay before shrinking */
			  }
			
			  #unified-extensions-manage-extensions {
			    min-height: 12px !important;
			    margin-bottom: 4px !important;
			  }
			}
			
			/* Layout for extensions */
			#unified-extensions-view #overflowed-extensions-list,
			#unified-extensions-view #unified-extensions-area,
			#unified-extensions-view .unified-extensions-list {
			  display: grid !important;
			  grid-template-columns: repeat(var(--firefoxcss-number-of-extensions-in-a-row), auto);
			  justify-items: left !important;
			  align-items: left !important;
			}
			
			/* Hide faded extensions */
			@media -moz-pref("mod.hide.faded-extensions.inside.extensions-menu") {
			  #unified-extensions-view #unified-extensions-area + .unified-extensions-list {
			    display: none !important;
			  }
			}
			
            '';
          };
        };
};
}
