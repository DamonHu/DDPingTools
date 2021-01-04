Pod::Spec.new do |s|
s.name = 'HDPingTools'
s.swift_version = '5.0'
s.version = '1.0.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = "IOS Ping tool, based on Apple's simplePing project"
s.homepage = 'https://github.com/DamonHu/HDPingTools'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/HDPingTools.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '10.0'
s.source_files = "HDPingTools/HDPingTools/*.{h,m,swift}"
# s.public_header_files = 'HDPingTools/HDPingTools/SimplePing.h'
s.frameworks = 'Foundation'
s.documentation_url = 'https://github.com/DamonHu/HDPingTools'
end