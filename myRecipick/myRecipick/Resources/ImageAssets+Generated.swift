// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Images {
  internal static let bottom = ImageAsset(name: "bottom")
  internal static let editCheck = ImageAsset(name: "editCheck")
  internal static let editNonCheck = ImageAsset(name: "editNonCheck")
  internal static let evaCloseFill = ImageAsset(name: "evaCloseFill")
  internal static let iconClose = ImageAsset(name: "iconClose")
  internal static let iconPlus = ImageAsset(name: "iconPlus")
  internal static let iconSwitch = ImageAsset(name: "iconSwitch")
  internal static let iconsListEmpty = ImageAsset(name: "iconsListEmpty")
  internal static let iconsNavigation24ArrowClose = ImageAsset(name: "iconsNavigation24ArrowClose")
  internal static let iconsNavigation24ArrowLeft = ImageAsset(name: "iconsNavigation24ArrowLeft")
  internal static let iconsNavigation32History = ImageAsset(name: "iconsNavigation32History")
  internal static let iconsNavigation32Home = ImageAsset(name: "iconsNavigation32Home")
  internal static let iconsNavigation32Plus = ImageAsset(name: "iconsNavigation32Plus")
  internal static let sample = ImageAsset(name: "sample")
  internal static let tip11 = ImageAsset(name: "tip11")
  internal static let tip21 = ImageAsset(name: "tip21")
  internal static let tip31 = ImageAsset(name: "tip31")
  internal static let uilBars = ImageAsset(name: "uilBars")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
