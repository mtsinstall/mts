# This is installation script for Tango test scripts.
# Confluence page: http://confluence.tango.corp/display/QA/Mobile+Test+Utils

class Mtu < Formula
    homepage "http://confluence.tango.corp/pages/viewpage.action?pageId=5716692"
    url "https://github.tango.me/mfilkov/mtu.git"
    version "3.0.0"

    depends_on 'bash'
    depends_on 'python'
    depends_on 'ffmpeg'
    depends_on 'tiff2png'
    depends_on 'android-sdk'
    depends_on 'bash-completion'
    depends_on 'ideviceinstaller'
    depends_on 'libimobiledevice'

    def install
        inreplace 'mtu' do |t|
            t.gsub! /\$\{UTILS_SHARE_PREFIX\}/, share/""
        end
        bin.install 'mtu'
        (share/"mtu/action").install Dir["action/*"]
        (share/"mtu/framework").install Dir["framework/*"]
        (share/"mtu/framework").install Dir["requirements.txt"]
    end

    def post_install
        Mtu.set_android_home
        Mtu.install_android_sdk_platform_tools
        Mtu.install_py_packages
        Mtu.activate_python_argcomplete
        Mtu.set_colorized_logs_format
        Mtu.enable_bash_completion
        Mtu.enable_updated_bash
        `source ~/.bash_profile`
        `reset`
        Mtu.show_colorized("MTU has been installed successfully! Use the command 'mtu' to start", "green")
    end

    def self.set_android_home
        sdk_ver = `ls /usr/local/Cellar/android-sdk/ | head -1`
        bash_profile = `cat ~/.bash_profile 2>&1`
        if ! bash_profile.include? "ANDROID_HOME="
            `echo "\nexport ANDROID_HOME=/usr/local/Cellar/android-sdk/#{sdk_ver.strip}/\n" >> ~/.bash_profile`
        end
    end

    def self.install_android_sdk_platform_tools
        `ls -la /usr/local/Cellar/android-sdk/*/platform-tools &> /dev/null`
        if $?.exitstatus == 0
            return
        end
        Mtu.show_colorized("Installing Android SDK platform-tools...", "green")
        `echo "y" | android update sdk --no-ui --filter 'platform-tools'`
    end

    def self.activate_python_argcomplete
        `ln -sf /usr/local/etc/bash_completion.d /etc/bash_completion.d`
        `/usr/local/bin/activate-global-python-argcomplete`
    end

    def self.install_py_packages()
        Mtu.show_colorized("Installing Python packages", "green")
        `pip install -r "/usr/local/share/mtu/framework/requirements.txt"`
        if $?.exitstatus != 0
            exit(1)
        end
    end

    def self.enable_bash_completion
        bash_profile = `cat ~/.bash_profile 2>&1`
        if ! bash_profile.include? "/etc/bash_completion"
            open(File.expand_path("~/.bash_profile"), "a") { |f|
                f.puts "\nif [ -f `brew --prefix`/etc/bash_completion ]; then\n\t. `brew --prefix`/etc/bash_completion\nfi\n"
            }
            `source ~/.bash_profile`
        end
    end

    def self.set_colorized_logs_format
        bash_profile = `cat ~/.bash_profile 2>&1`
        if ! bash_profile.include? "COLOREDLOGS_LOG_FORMAT"
            `echo "\nexport COLOREDLOGS_LOG_FORMAT='%(message)s'\n" >> ~/.bash_profile`
        end
    end

    def self.enable_updated_bash
        etc_shells = `cat /etc/shells 2>&1`
        if ! etc_shells.include? "/usr/local/bin/bash"
            `bash -c 'echo /usr/local/bin/bash >> /etc/shells'`
        end
        `chsh -s '/usr/local/bin/bash'`
    end

    def self.show_colorized(msg, color)
        if color == "red"
            puts "\e[\033[31m#{msg}\e[0m"
        end
        if color == "green"
            puts "\e[\033[32m#{msg}\e[0m"
        end
    end

end
