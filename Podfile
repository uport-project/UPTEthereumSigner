target 'UPTEthereumSigner' do
    platform :ios, '9.0'
    use_frameworks!
    pod 'Valet'
    pod 'CoreEthereum', :git => 'https://github.com/wjmelements/CoreBitcoin.git', :tag => '1.0.0'
    target 'UPTEthereumSignerTests' do
      inherit! :search_paths
      pod 'Specta'
      pod 'Expecta'
    end
end
