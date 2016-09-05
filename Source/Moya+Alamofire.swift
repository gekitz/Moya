import Foundation
import Alamofire

/// Choice of parameter encoding.
public typealias ParameterEncoding = Alamofire.ParameterEncoding

public typealias Manager = Alamofire.SessionManager

/// Make the Alamofire Request type conform to our type, to prevent leaking Alamofire to plugins.
extension Request: RequestType { }

/// Internal token that can be used to cancel requests
public final class CancellableToken: Cancellable , CustomDebugStringConvertible {
    let cancelAction: () -> Void
    let request : Request?
    private(set) var canceled: Bool = false
    
    private var lock: OSSpinLock = OS_SPINLOCK_INIT
    
    public func cancel() {
        OSSpinLockLock(&lock)
        defer { OSSpinLockUnlock(&lock) }
        guard !canceled else { return }
        canceled = true
        cancelAction()
    }
    
    init(action: @escaping () -> Void){
        self.cancelAction = action
        self.request = nil
    }
    
    init(request : Request){
        self.request = request
        self.cancelAction = {
            request.cancel()
        }
    }
    
    public var debugDescription: String {
        guard let request = self.request else {
            return "Empty Request"
        }
        return request.debugDescription
    }
    
}
