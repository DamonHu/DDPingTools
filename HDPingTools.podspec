Pod::Spec.new do |s|
s.name = 'HDPingTools'
s.swift_version = '5.0'
s.version = '1.1.1'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = "iOS Ping tool, based on Apple's simplePing project"
s.homepage = 'https://github.com/DamonHu/HDPingTools'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/HDPingTools.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '10.0'
s.source_files = "HDPingTools/HDPingTools/*.{h,m,swift}"
s.frameworks = 'Foundation'
s.documentation_url = 'https://github.com/DamonHu/HDPingTools'
end