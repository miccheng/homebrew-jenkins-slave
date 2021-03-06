class JenkinsSlave < Formula

  desc "Jenkins Slave for macOS"
  homepage "https://jenkins.io/projects/remoting/"
  url "http://repo.jenkins-ci.org/releases/org/jenkins-ci/main/remoting/3.14/remoting-3.14.jar"
  sha256 "2539c1ace877de6bc4c013d59ff68548024d04b178bd74c24cff0374c28099dc"

  depends_on :java => "1.8+"
  bottle :unneeded

  def install
    libexec.install "remoting-#{version}.jar"
    bin.write_jar_script libexec/"remoting-#{version}.jar", "remoting"
  end

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
	<key>UserName</key>
	<string>#{ENV["USER"]}</string>
        <array>
          <string>/usr/bin/java</string>
          <string>-jar</string>
          <string>#{libexec}/remoting.jar</string>
          <string>-jnlpUrl</string>
          <string>REPLACE_ME_JENKINS_URL</string>
          <string>-secret</string>
          <string>REPLACE_ME_JENKINS_SECRET</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
	<true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/jenkins-slave.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/jenkins-slave.log</string>
        <key>SessionCreate</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  def plist_name
    "com.ribose.jenkins.slave"
  end

  def caveats; <<~EOS
    WARNING:
      You must configure the JENKINS_URL and JENKINS_SECRET variables in the plist file:

    Step 1: Set your JENKINS_URL / JENKINS_SECRET in the environment:

      export url="https://my-jenkins.com/computer/agentname/slave-agent.jnlp"
      export secret="bd38130d1412b54287a00a3750bd100c"

    Step 2: Insert the JENKINS_URL / JENKINS_SECRET in the plist and ensure that JENKINS_SECRET is not stored in the bash history:

      sed -i "" "s@REPLACE_ME_JENKINS_URL@${url}@" #{prefix/(plist_name+".plist")}
      sed -i "" "s@REPLACE_ME_JENKINS_SECRET@${secret}@" #{prefix/(plist_name+".plist")}
      unset HISTFILE url secret

    Step 3: Start the Jenkins Slave via brew services

      If you want to start on machine boot, use `sudo`:

      sudo brew services start riboseinc/jenkins-slaves/jenkins-slave

      If you want to start on login, just do this:

      brew services start riboseinc/jenkins-slaves/jenkins-slave


    *Ignore what brew tells you below!*
    -------------vvvvvvv-------------
     \\------------vvvvv------------/
      \\------------vvv------------/
       \\------------v------------/
    EOS
  end

end
