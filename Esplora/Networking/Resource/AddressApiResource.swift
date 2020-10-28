
import Foundation

struct AddressApiResource {
    var address: String
}

extension AddressApiResource: ResourceType {
    var baseURL: URL {
        guard let url = URL(string: "https://blockstream.info/testnet/api/address/") else {
            fatalError(baseURLFailureMessage)
        }
        return url
    }

    var path: String {
        return "\(address)"
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: nil,
                                            bodyEncoding: encoding,
                                            urlParameters: nil,
                                            additionHeaders: nil)
    }

    var encoding: ParameterEncoding {
        return .jsonEncoding
    }
}
