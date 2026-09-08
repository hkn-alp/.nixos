{ pkgs, ... }: {
  programs.firefox = {
    enable = true;

    # 1. Enterprise Policies: Hardware-level & Network Lockdowns
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      DisableSetDesktopBackground = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;

      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://sky.rethinkdns.com/1:YASAAQBwIAA=";
        Locked = true;
        Fallback = false;
      };

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    # 2. System-Wide Preferences (about:config overrides)
    # Translated from Home Manager 'profiles.default.settings' to NixOS 'preferences'
    preferences = {
      # --- FINGERPRINTING PROTECTION ---
      "privacy.resistFingerprinting" = true;
      "privacy.window.maxInnerWidth" = 1600;
      "privacy.window.maxInnerHeight" = 900;

      # --- COOKIE FIX (Keeps you logged in) ---
      "network.cookie.cookieBehavior" = 5;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.cache" = true;
      "privacy.clearOnShutdown.history" = false;

      # --- NETWORK & TELEMETRY ---
      "network.dns.disablePrefetch" = true;
      "network.prefetch-next" = false;
      "browser.ping-centre.telemetry" = false;

      # --- UI CLEANUP ---
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    };
  };
}
