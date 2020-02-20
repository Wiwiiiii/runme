# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MoonRunner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MoonRunner
    pod 'SwiftGifOrigin', '~> 1.7.0'
    pod "PromiseKit"
    pod 'Alamofire'
    pod 'SwiftyJSON'

  # add the Firebase pod for Google Analytics
    pod 'Firebase/Analytics'

  #Pod for lint

    pod 'SwiftLint'

  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '4.2'
  end
end
