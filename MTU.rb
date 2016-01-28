# This is installation script for Tango test scripts.
# Confluence page: http://confluence.tango.corp/display/QA/Mobile+Test+Utils

class Mtu < Formula
    homepage "http://confluence.tango.corp/pages/viewpage.action?pageId=5716692"
    url "https://github.tango.me/mfilkov/mtu.git"
    version "3.0.0"

    depends_on 'ffmpeg'
    depends_on 'tiff2png'
    depends_on 'bash-completion'
    depends_on 'android-sdk'
    depends_on 'ideviceinstaller'
    depends_on 'libimobiledevice'

    def install
        inreplace 'mtu' do |t|
            t.gsub! /\$\{UTILS_SHARE_PREFIX\}/, share/""
        end
        bin.install 'mtu'
        (share/"mtu/action").install Dir["action/*"]
        (share/"mtu/framework").install Dir["framework/*"]
    end
end
