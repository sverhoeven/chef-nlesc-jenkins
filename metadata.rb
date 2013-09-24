name             'nlesc-jenkins'
maintainer       'Netherlands eScience Center'
maintainer_email 'info@esciencecenter.nl'
license          'Apache 2.0'
description      'Installs/Configures nlesc-jenkins'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "nlesc-base"
depends "jenkins"
depends "ssh", ">= 0.6.4"
depends "build-essential"
depends "nodejs"
depends "npm"
depends "python"
depends "cmake"
depends "rvm"
depends "postfix"
depends "maven"
depends "ant"
depends "xml"
depends "boost"
depends "xvfb"

