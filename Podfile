# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Taxidio' do
  # Pods for Taxidio
    
	source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '12.0'

    pod 'BLMultiColorLoader' 
#   pod 'Firebase'

	pod 'AFNetworking', '~> 3.0'
    pod 'GoogleSignIn'
    pod 'MARKRangeSlider'
    #    pod 'JNExpandableTableView'
    pod 'GoogleMaps'
    pod 'LXReorderableCollectionViewFlowLayout', '~> 0.2'
    pod 'Mapbox-iOS-SDK'
    pod 'BetweenKit'
    pod 'GKImagePicker', '~> 0.0'
    pod 'HCSStarRatingView', '~> 1.5'
    pod 'CBZSplashView', '~> 1.0.0'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'HMSegmentedControl'
    pod 'UITextView+Placeholder', '~> 1.2'
    pod 'MPCoachMarks'
    pod 'Firebase'
    pod 'Firebase/Messaging'
#    pod 'FirebaseUI', '= 0.2.6'
    
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/DynamicLinks'
    #pod 'Bolts'
    #pod 'FBSDKCoreKit'
    #pod 'FBSDKLoginKit'
    #pod 'FacebookCore'
    #pod 'FacebookLogin'
    #pod 'FacebookShare'
    pod 'GooglePlaces', '~> 2.7.0'
target 'TaxidioTests' do
    inherit! :search_paths
    # Pods for testing

  end

  target 'TaxidioUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
              config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
          end
      end
  end
end
