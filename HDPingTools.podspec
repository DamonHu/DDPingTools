Pod::Spec.new do |s|
s.name = 'HDPingTools'
s.swift_version = '5.0'
s.version = '2.0.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = "iOS Ping tool, based on Apple's simplePing project"
s.homepage = 'https://github.com/DamonHu/HDPingTools'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/HDPingTools.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.subspec 'core' do |cs|
    cs.source_files = "pod/*.{h,m,swift}"
end

s.default_subspecs = "core"
s.frameworks = 'Foundation'
s.documentation_url = 'https://github.com/DamonHu/HDPingTools'
end