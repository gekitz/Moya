import Foundation
import Result

/// Provides each request with optional NSURLCredentials.
public final class CredentialsPlugin: PluginType {

    public typealias CredentialClosure = (TargetType) -> URLCredential?
    let credentialsClosure: CredentialClosure

    public init(credentialsClosure: CredentialClosure) {
        self.credentialsClosure = credentialsClosure
    }

    // MARK: Plugin

    public func willSendRequest(_ request: RequestType, target: TargetType) {
        if let credentials = credentialsClosure(target) {
            request.authenticate(usingCredential: credentials)
        }
    }

    public func didReceiveResponse(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
    }
}
