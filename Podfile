# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
#ignore all warnings from all pods

target 'Hype' do
use_frameworks!
inhibit_all_warnings!
#Global Frameworks and Utilities
pod 'CocoaLumberjack'
pod 'Masonry', '~> 0.6'
pod 'NUI', '~> 0.5'
pod 'ReactiveCocoa'
pod 'Bolts'
pod 'BFKit'
pod 'DateTools', '~> 1.6'
pod 'YapDatabase', '~> 2.7'
pod 'EKAlgorithms', '~> 0.2'
pod 'AutoCoding', '~> 2.2'
pod 'SDWebImage', '~> 3.7'
pod 'FormatterKit', '~> 1.8'
pod 'Typhoon', '~> 3.3'
pod 'Mixpanel'

#Debugging
pod 'FLEX', '~> 2.0', :configurations => ['Debug']
pod 'Reveal-iOS-SDK', :configurations => ['Debug']

#Sugar
pod 'LinqToObjectiveC', '~> 2.0'
pod 'ObjectiveSugar'
pod 'GCDObjC', '~> 0.2'
pod 'BlocksKit', '~> 2.2'
pod "ReflectableEnum"

#Parse/Facebook
pod 'Parse'
pod 'ParseFacebookUtilsV4'
pod 'ParseUI'
pod 'FBSDKCoreKit'

#Intercom
pod 'Intercom'

#Fabric
pod 'Fabric'
pod 'Crashlytics'
pod 'Digits'
pod 'Stripe'

#Branch
pod "Branch"

#Helpers
pod 'SSDataSources', '~> 0.8'
pod 'YLMoment', '~> 0.2.0'
pod 'APAddressBook', '~> 0.2.1’
pod 'libPhoneNumber-iOS', '~> 0.8'
pod 'LMGeocoder'
pod 'TTTAttributedLabel'
pod 'Harpy'
pod 'SwiftDate'

#UI
pod 'SVPullToRefresh'
pod "ORStackView"
pod 'SVProgressHUD'
pod 'THContactPicker', '~> 1.2'
pod 'IHKeyboardAvoiding'
pod "FXLabel"
pod 'BLKFlexibleHeightBar'
end

target 'HypeTests' do
pod 'OCMock', '3.1.2'
pod "Gizou"
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            settings = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
#            settings = ['$(inherited)'] if settings.nil?
#            
#            if target.name == 'Pods-MyProject-Mixpanel'
#                settings << 'MIXPANEL_DEBUG=1'
#                settings << 'MIXPANEL_ERROR=1'
#            end
#            
#            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = settings
#        end
#    end
#end
