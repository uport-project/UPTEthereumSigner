target 'UPTEthereumSigner' do
    platform :ios, '9.0'
    use_frameworks!
    pod 'Valet', :git => 'https://github.com/wjmelements/Valet.git', :branch => 'swift-version'
    pod 'CoreBitcoin', :git => 'https://github.com/wjmelements/CoreBitcoin.git', :branch => 'hsp'
    target 'UPTEthereumSignerTests' do
      inherit! :search_paths
      pod 'Specta'
      pod 'Expecta'
    end
end
