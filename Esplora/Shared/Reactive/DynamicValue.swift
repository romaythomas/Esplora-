
import Foundation

class DynamicValue<T> {
  typealias CompletionHandler = ((T) throws -> Void)
  var value : T {
    didSet {
      let value = self.value
      DispatchQueue.main.async {
        self.notify(value: value)
      }
    }
  }

  private var observers = [String: CompletionHandler]()

  init(_ value: T) {
    self.value = value
  }

  public func addObserver(_ observer: Identifiable, completionHandler: @escaping CompletionHandler) rethrows {
    observers[observer.identifier] = completionHandler
  }

  public func addAndNotify(observer: Identifiable, completionHandler: @escaping CompletionHandler) rethrows {
    try self.addObserver(observer, completionHandler: completionHandler)
    self.notify(value: self.value)
  }

  public func removeAllObservers() {
    self.observers.removeAll()
  }

  private func notify(value: T) {
    observers.forEach({ try? $0.value(value) })
  }

  deinit {
    observers.removeAll()
  }
}

protocol Identifiable {
  var identifier: String { get }
}

extension NSObject: Identifiable {
  var identifier: String {
    return self.description
  }
}
