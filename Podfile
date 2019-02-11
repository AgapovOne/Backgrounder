platform :ios, '10.0'
inhibit_all_warnings!

target 'Backgrounder' do
  use_frameworks!

  # Networking
  pod 'Moya/RxSwift'
  pod 'AlamofireNetworkActivityIndicator'

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxOptional'

  # Default pods
  pod 'Reusable'
  pod 'Kingfisher'

  # UI
  pod 'Cartography'
  pod 'SwiftIconFont'
  pod 'SwiftMessages'
  pod 'Hero'
  pod 'Hue'
  pod 'RxDataSources'

  # Helpers
  pod 'SwiftLint'
  pod 'Reveal-SDK'

  target 'BackgrounderTests' do
    inherit! :search_paths
  end
end

plugin 'cocoapods-keys', {
    :project => "Backgrounder",
    :keys => [
        "UnsplashAPIClientKey",
        "UnsplashAPISecretKey",
        ],
}
