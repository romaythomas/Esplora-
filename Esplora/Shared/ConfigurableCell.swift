
import UIKit

protocol ConfigurableCell {
  static var identifier: String { get }
  static var nib: UINib { get }
}

extension ConfigurableCell {
  static var identifier: String {
    return String(describing: Self.self)
  }
  
  static var nib: UINib {
    return UINib(nibName: String(describing: Self.self), bundle: nil)
  }
}
