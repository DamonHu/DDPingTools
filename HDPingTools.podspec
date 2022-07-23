Pod::Spec.new do |s|
s.name = 'HDPingTools'
s.swift_version = '5.0'
s.version = '1.2.9'
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
s.subspec 'zxkit' do |cs|
    cs.resource_bundles = {
      'HDPingTools' => ['pod/assets/**/*.png']
    }
    cs.dependency 'HDPingTools/core'
    cs.dependency 'ZXKitCore/core'
    cs.dependency 'ZXKitLogger/zxkit'
    cs.source_files = "pod/zxkit/*.swift"
end

s.default_subspecs = "core"
s.frameworks = 'Foundation'
s.documentation_url = 'https://github.com/DamonHu/HDPingTools'
end