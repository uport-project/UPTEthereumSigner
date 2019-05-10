target 'UPTEthereumSigner' do
    platform :ios, '9.0'
    use_frameworks!
    pod 'Valet', '~> 2.4.2'
    pod 'CoreEthereum', :git => 'https://github.com/wjmelements/CoreEthereum.git', :commit => 'c40e93062d0dc490dcd854280b8f0d8c3f1a3899'
    target 'UPTEthereumSignerTests' do
      inherit! :search_paths
      pod 'Specta'
      pod 'Expecta'
    end
end
