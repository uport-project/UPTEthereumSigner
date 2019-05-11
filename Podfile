target 'UPTEthereumSigner' do
    platform :ios, '9.0'
    use_frameworks!
    pod 'Valet', '~> 2.4.2'
    pod 'CoreEthereum', :git => 'https://github.com/wjmelements/CoreEthereum.git', :commit => 'd63e3826ab9d905d599c91e191af67401deffe4a'
    target 'UPTEthereumSignerTests' do
      inherit! :search_paths
      pod 'Specta'
      pod 'Expecta'
    end
end
