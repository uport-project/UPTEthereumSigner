pre_install do |installer|
	# workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
	Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
target 'UPTEthereumSigner' do
    platform :ios, '9.0'
    use_frameworks!
    pod 'Valet'
    pod 'CoreBitcoin', :git => 'https://github.com/wjmelements/CoreBitcoin.git', :branch => 'min-core-bitcoin'
end
