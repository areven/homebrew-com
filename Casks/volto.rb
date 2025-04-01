cask "volto" do
  version "0.2.2"
  sha256 "336afe2a04ede0aba54353490848758af837910b9a99ca117067796772ab7bf3"

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
