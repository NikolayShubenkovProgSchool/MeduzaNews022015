# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'MeduzaNews' do

pod 'Alamofire', '~> 3.2'
pod 'MagicalRecord', '~> 2.3'
pod 'ChameleonFramework/Swift', '~> 2.1'

end


post_install do |installer|
    target = installer.pods_project.targets.find{|t| t.to_s == "MagicalRecord"}
    target.build_configurations.each do |config|
        s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
        s = [ '$(inherited)' ] if s == nil;
        s.push('MR_LOGGING_DISABLED=1') if config.to_s == "Debug";
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
    end
end
