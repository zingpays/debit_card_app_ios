# Uncomment the next line to define a global platform for your project

platform :ios, '13.0'

target 'DCard' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Network extension https://github.com/ivanbruel/Moya-ObjectMapper
  pod 'Moya-ObjectMapper'

  # Swift layout https://github.com/SnapKit/SnapKit
  pod 'SnapKit'
  
  # Swift code generator https://github.com/SwiftGen/SwiftGen
  pod 'R.swift'
  
  # Swift extension https://github.com/SwifterSwift/SwifterSwift
  pod 'SwifterSwift'
  
  # Network status check lib https://github.com/nicklockwood/SwiftFormat
  pod 'ReachabilitySwift'
  
  # Date parse lib https://github.com/malcommac/SwiftDate
  pod 'SwiftDate'
  
  # keyboard manager https://github.com/hackiftekhar/IQKeyboardManager
  pod 'IQKeyboardManagerSwift'
  
  # banner view https://github.com/WenchaoD/FSPagerView
  pod 'FSPagerView'
  
  # Toast https://github.com/scalessec/Toast-Swift
  pod 'Toast-Swift'
  
  # GPassword https://github.com/hackjie/GPassword
  pod "GPassword"
  
  # GKNavigationBarSwift https://github.com/QuintGao/GKNavigationBarSwift
  pod 'GKNavigationBarSwift'
  
  pod 'CRBoxInputView'
  
  # https://github.com/JerryFans/JFPopup
  pod 'JFPopup'
  
  # https://github.com/danielgindi/Charts
  pod 'Charts'
  
  # https://github.com/pujiaxin33/JXSegmentedView
  pod 'JXSegmentedView'
  
  # Date parse lib https://github.com/malcommac/SwiftDate
  pod 'SwiftDate'
  
  # https://developers.veriff.com/#adding-the-sdk-to-the-project
  pod 'VeriffSDK'
  
  # https://github.com/CoderMJLee/MJRefresh
  pod 'MJRefresh'

  target 'DCardTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DCardUITests' do
    # Pods for testing
  end

end

deployment_target = '13.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
            end
        end
        project.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end
