Capybara.asset_host = 'http://localhost:3000'

SCREENSHOT_FILE = "tmp/screenshot.png"
def show
  File.delete SCREENSHOT_FILE if File.exist? SCREENSHOT_FILE
  system "xdg-open #{save_screenshot SCREENSHOT_FILE}"
end