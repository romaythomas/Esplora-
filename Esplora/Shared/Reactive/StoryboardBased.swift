
import Foundation
import UIKit

public protocol StoryboardBased: class {
  static var storyboardName: String { get }
  static var storyboard: UIStoryboard { get }
  static var viewControllerId: String { get }
}

public extension StoryboardBased {
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
  }

  static var viewControllerId: String {
    return String(describing: self)
  }
}

public extension StoryboardBased where Self: UIViewController {
  static func instantiate() -> Self {
    guard
      let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId) as? Self
      else {
        fatalError("The VC of \(storyboard) is not of class \(self)")
    }
    if #available(iOS 13.0, *) {
      if viewController.modalPresentationStyle == .automatic || viewController.modalPresentationStyle == .pageSheet {
        viewController.modalPresentationStyle = .fullScreen
      }
    }
    return viewController
  }
}
