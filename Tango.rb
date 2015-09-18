# This is installation script for Tango test scripts.
# Confluence page: http://confluence.tango.corp/display/QA/Mobile+Test+Utils

class Tango < Formula
    homepage "http://confluence.tango.corp/pages/viewpage.action?pageId=5716692"
    url "https://github.tango.me/mfilkov/tango-test-scripts.git"
    version "0.0.1"

    depends_on 'ffmpeg'
    depends_on 'tiff2png'
    depends_on 'bash-completion'
    depends_on 'android-sdk'
    depends_on 'ideviceinstaller'
    depends_on 'libimobiledevice'

    def install
        inreplace 'src/tango' do |t|
            t.gsub! /\$\{UTILS_SHARE_PREFIX\}/, share/"tango"
        end
        inreplace 'src/bash-completion/tango' do |t|
            t.gsub! /\$\{UTILS_SHARE_PREFIX\}/, share/"tango"
        end
        bin.install 'src/tango'
        (share/"tango").install Dir["src/modules/*"]
        (etc/"bash_completion.d").install 'src/bash-completion/tango'
    end
end
