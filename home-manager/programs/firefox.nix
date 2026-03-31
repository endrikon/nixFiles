{defaultUser, ...}: {
  enable = true;

  profiles.default.settings = {
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "browser.theme.content-theme" = 2; # 0: Default, 1: Light, 2: Dark
    "browser.theme.toolbar-theme" = 2;
    "ui.systemUsesDarkTheme" = 1;
  };
  policies = {
    BlockAboutConfig = true;
    DefaultDownloadDirectory = "/home/${defaultUser}/Downloads";

    # https://mozilla.github.io/policy-templates/#extensionsettings
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        default_area = "toolbar";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
      "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
        default_area = "navbar";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
      "addon@darkreader.org" = {
        default_area = "navbar";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
      "{458160b9-32eb-4f4c-87d1-89ad3bdeb9dc}" = {
        default_area = "menupanel";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-anti-translate/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
      "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = {
        default_area = "menupanel";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/videospeed/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
    };
  };
}
