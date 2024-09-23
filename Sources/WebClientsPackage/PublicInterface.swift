import Foundation
import WebClientsPackage

public struct WebClientError: Error {
    public enum ErrorKind: Sendable {
        case generalError
    }
    let kind: ErrorKind
    var reason: String?
    public init(kind: ErrorKind, reason: String? = nil) {
        self.kind = kind
        self.reason = reason
    }
}

func example() async throws {
    let parsed_url = try ParsedURL("https://fenyo.net/")
    let credentials: CredentialsContainer = ["domotique": (/* StaticCredentials.login */ "foo", /* StaticCredentials.password */ "bar")]
    let session = try WebClientSession(config: AccessNetworkConfig(is_check_ssl: false, credentials: credentials))
    let (data, request, response) = try await session.fetch(target: parsed_url.toTarget())
    guard let data, let request, let response else {
        throw WebClientError(kind: .generalError, reason: "invalid fetch results")
    }
    let html = try HTML(data: data, response: response)
    print(response)
    print(html.content)
}
