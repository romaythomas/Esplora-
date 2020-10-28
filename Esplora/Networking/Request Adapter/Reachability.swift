
import Foundation
import SystemConfiguration

class Reachability {
    static let shared = Reachability()
    
    private init() {
        // Private init for singleton
    }
    
     private let queue = DispatchQueue.main
     private var currentReachabilityFlags: SCNetworkReachabilityFlags?
    private var isListening = false
    
    func isConnectedToNetwork() -> Bool {
        if #available(iOS 9.0, OSX 10.10, *) {
            var zeroAddress = sockaddr_in6()
            zeroAddress.sin6_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin6_family = sa_family_t(AF_INET6)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, { pointer in
                pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) { return SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
            }

            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            return (isReachable && !needsConnection)
        } else { var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, { pointer in
                pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) { return SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
            }

            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            return (isReachable && !needsConnection)
        }
    }
}

class Handler {
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    // Queue where the `SCNetworkReachability` callbacks run
    private let queue = DispatchQueue.main
    // We use it to keep a backup of the last flags read.
    private var currentReachabilityFlags: SCNetworkReachabilityFlags?
    // Flag used to avoid starting listening if we are already listening
    private var isListening = false
    // Starts listening
    func start() {
        // Checks if we are already listening
        guard !isListening else { return }
        // Optional binding since `SCNetworkReachabilityCreateWithName` returns an optional object
        guard let reachability = reachability else { return }
        // Creates a context
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        // Sets `self` as listener object
        context.info = UnsafeMutableRawPointer(Unmanaged<Handler>.passUnretained(self).toOpaque())
        let callbackClosure: SCNetworkReachabilityCallBack? = {
            (reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            guard let info = info else { return }
            // Gets the `Handler` object from the context info
            let handler = Unmanaged<Handler>.fromOpaque(info).takeUnretainedValue()
            DispatchQueue.main.async {
                handler.checkReachability(flags: flags)
            }
        }
        // Registers the callback. `callbackClosure` is the closure where we manage the callback implementation
        if !SCNetworkReachabilitySetCallback(reachability, callbackClosure, &context) {
            // Not able to set the callback
        }
        // Sets the dispatch queue which is `DispatchQueue.main` for this example. It can be also a background queue
        if !SCNetworkReachabilitySetDispatchQueue(reachability, queue) {
            // Not able to set the queue
        }
        // Runs the first time to set the current flags
        queue.async {
            // Resets the flags stored, in this way `checkReachability` will set the new ones
            self.currentReachabilityFlags = nil
            // Reads the new flags
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)
            self.checkReachability(flags: flags)
        }
        isListening = true
    }
    // Called inside `callbackClosure`
    private func checkReachability(flags: SCNetworkReachabilityFlags) {
        if currentReachabilityFlags != flags {
            // Stores the new flags
            currentReachabilityFlags = flags
            
            
        }
    }
    // Stops listening
    func stop() {
        // Skips if we are not listening
        // Optional binding since `SCNetworkReachabilityCreateWithName` returns an optional object
        guard isListening,
            let reachability = reachability
            else { return }
        // Remove callback and dispatch queue
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        isListening = false
    }
}


