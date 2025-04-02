cask "volto" do
  version "0.3.0"
  sha256 "9f24cccb5cc58d2b43739798bfd7efb729fe8a63be21fe7c4c85086066029da9"

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
      system_command "/usr/bin/xattr", args: ["-rd", "com.apple.quarantine", "#{staged_path}/Volto.app"]
    rescue => e
      opoo "Failed to remove the quarantine flag: #{e.message}"
    end
  end

  uninstall quit:       "com.areven.volto",
            launchctl:  "com.areven.volto.daemon",
            login_item: "Volto.app"

  zap trash: [
    "~/Library/Caches/com.areven.volto",
    "~/Library/Preferences/com.areven.volto.plist",
    "/Library/Application Support/Areven/Volto"
  ]
end
