cask "volto" do
  version "0.1.0"
  sha256 "96c09a9817403298a6ab501ee4ad2025303cf6faac8a9ae7c4fc076066a4af8d"

  url "https://artifacts.areven.com/volto/#{version}/Volto.dmg"
  name "Volto"
  desc "Battery charging supervisor"
  homepage "https://areven.com/volto"

  depends_on macos: ">= :sonoma"
  depends_on arch: [:arm64]

  app "Volto.app"

  uninstall launchctl:  "com.areven.volto.daemon",
            quit:       "com.areven.volto",
            login_item: "Volto.app"

  zap trash: [
    "~/Library/Caches/com.areven.volto",
    "~/Library/Preferences/com.areven.volto.plist",
    "/Library/Application Support/Areven/Volto"
  ]
end
