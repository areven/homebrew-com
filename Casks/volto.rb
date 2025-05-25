cask "volto" do
  version "0.7.0"
  sha256 "142f5b5ee89b5392e581849022b9864b92187adf4247cda1d23118cb54a4efe6"

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
              ['TERM', 'com.areven.volto'], # try gracefully
              ['KILL', 'com.areven.volto'] # use a hammer
            ],
            launchctl: "com.areven.volto.daemon",
            login_item: "Volto"

  zap delete: [
        "~/Library/Preferences/com.areven.volto.plist",
        "~/Library/Caches/com.areven.volto",
        "~/Library/HTTPStorages/com.areven.volto",
        "/Library/Application Support/Areven/Volto",
      ],
      script: { # bust macos defaults cache
        executable: "/usr/bin/defaults",
        args: ["delete", "com.areven.volto"],
        sudo: false
      }
end
