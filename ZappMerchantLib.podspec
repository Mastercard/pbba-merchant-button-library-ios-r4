
Pod::Spec.new do |s|

  s.name         = "ZappMerchantLib"
  s.version      = "4.0.0"
  s.summary      = "The Pay by Bank app Merchant Library for iOS"

  s.description  = <<-DESC
                   The Pay by Bank app Merchant Library for iOS makes it easy for you to add Pay by Bank app as a new payment method.
                   DESC

  s.homepage = "http://paybybankapp.co.uk"
  s.license  = "Apache 2.0"
  s.authors  = "Ujjwal Chafle"
  s.platform = :ios, '9.0'

  s.source = { :git => 'https://github.com/Mastercard/pbba-merchant-button-library-ios-R4.git', :tag => s.version.to_s }
  
  s.public_header_files = [
    "ZappMerchantLib/ZappMerchantLib.h",
    "ZappMerchantLib/PBBATypes.h",
    "ZappMerchantLib/PBBAAppUtils.h",
    "ZappMerchantLib/PBBAButton.h",
    "ZappMerchantLib/PBBAPopupViewController.h",
    "ZappMerchantLib/PBBAUIElementAppearance.h",
    "ZappMerchantLib/PBBAAnimatable.h",
    "ZappMerchantLib/PBBALibraryUtils.h"
  ]

  s.source_files = "ZappMerchantLib/**/*.{h,m}"

  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.ios.resource_bundle = { 'ZappMerchantLibResources' => [
      "ZappMerchantLibResources/**/*.ttf",
     "ZappMerchantLibResources/**/*.strings",
      "ZappMerchantLibResources/**/*.lproj", 
      "ZappMerchantLibResources/*.xcassets",
      "ZappMerchantLib/**/*.xib",
      "ZappMerchantLib/**/*.storyboard",
      "ZappMerchantLib/**/*.lproj"
    ] 
  }
end
