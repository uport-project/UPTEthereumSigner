#
# Be sure to run `pod lib lint UPTEthereumSigner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'UPTEthereumSigner'
s.version          = '1.0.9'
s.summary          = 'Ethereum signer library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
Manages public/private keys along with related Ethereum addresses
Signs Ethereum transactions and JWTs with a provided protection level
DESC

s.homepage         = 'https://github.com/uport-project/UPTEthereumSigner'
s.license          = { :type => 'APACHE', :file => 'LICENSE' }
s.author           = { 'josh' => 'joshua.bell@consensys.net' }
s.author           = { 'William Morriss' => 'william.morriss@consensys.net' }
s.author           = { 'Pelle Braendgaard' => 'pelle.braendgaard@consensys.net' }
s.source           = { :git => 'https://github.com/uport-project/UPTEthereumSigner.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.3'

s.source_files = 'UPTEthereumSigner/Classes/**/*'

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'CoreEthereum', 'AVFoundation'
s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '/Applications/Xcode.app/Contents/Developer/Library/Frameworks' }
s.pod_target_xcconfig = {
  'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/CoreEthereum" "${PODS_ROOT}/CoreEthereum/openssl/include"',
}
s.dependency 'Valet', '~> 2.4.2'
s.dependency 'CoreEthereum'
end

