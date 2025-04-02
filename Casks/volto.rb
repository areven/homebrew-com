cask "volto" do
  version "0.4.0"
  sha256 "58d9cf5d85cc4ba06875fc127fb81037622a248b74e4fb23ae83e7cedfd32dca"

  url "https://artifacts.areven.com/volto/#{version}/Volto.dmg"
  name "Volto"
  desc "Battery charging supervisor"
  homepage "https://areven.com/volto"

  depends_on macos: ">= :sonoma"
  depends_on arch: [:arm64]

  app "Volto.app"

  livecheck do
    url "https://artifacts.areven.com/volto/appcast.xml"
    strategy :sparkle, &:version
  end

  postflight do
    begin
      ohai "Removing the quarantine flag"
      system_command "/usr/bin/xattr", args: ["-rd", "com.apple.quarantine", "#{appdir}/Volto.app"]
    rescue => e
      opoo "Failed to remove the quarantine flag: #{e.message}"
    end

    running_apps = system_command("ps", args: ["-e"])
    if running_apps.stdout.include?("/Applications/Volto.app/Contents/MacOS/Volto")
      ohai "Restarting Volto"
      system_command("pkill", args: ["-TERM", "Volto"])
      sleep 1
      system_command("open", args: ["/Applications/Volto.app"])
    end
  end

  uninstall signal: [
              ['TERM', 'com.areven.volto'],
              ['KILL', 'com.areven.volto']
            ],
            launchctl: "com.areven.volto.daemon",
            login_item: "Volto"

  zap delete: [
    "~/Library/Preferences/com.areven.volto.plist",
    "~/Library/Caches/com.areven.volto",
    "/Library/Application Support/Areven/Volto"
  ]
end
