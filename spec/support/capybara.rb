Capybara.asset_host = 'http://localhost:3000'

# rubocop:disable Lint/Debugger
def show
  filename = 'tmp/screenshot.png'
  File.delete filename if File.exist? filename
  system "xdg-open #{save_screenshot filename}"
end
