cask "volto" do
  version "0.2.1"
  sha256 "b1d2c9dca0c10b4564fa84e17c6868fab334e3350ab6370695e01cf711d50298"

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
