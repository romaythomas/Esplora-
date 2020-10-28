
import Foundation

protocol ResourceType {
    var baseURLFailureMessage: String { get }
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameter: Parameters { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    func makeRequest() throws -> URLRequest
}

extension ResourceType {
    var baseURLFailureMessage: String {
        return "baseURL could not be configured."
    }
    
    var baseURL: URL {
        guard let url = URL(string: "https://test") else {
            fatalError(baseURLFailureMessage)
        }
        return url
    }

    var task: HTTPTask {
        return .request
    }

    var parameter: Parameters {
        return [:]
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var encoding: ParameterEncoding {
        return .urlEncoding
    }
}

extension ResourceType {
    func makeRequest() throws -> URLRequest {
        return try self.makeRequest(for: self.baseURL.absoluteString, with: httpMethod)
    }

    func makeRequest(for host: String, with httpMethod: HTTPMethod?) throws -> URLRequest {
      var request = URLRequest(url: self.baseURL.appendingPathComponent(self.path),
                                    cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
           request.httpMethod = httpMethod?.rawValue
        request.httpMethod = httpMethod?.rawValue
        switch self.task {
        case .request:
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")\ "Content-Type": "application/x-www-form-urlencoded",
          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .requestParameters(let bodyParameters,
                                let bodyEncoding,
                                let urlParameters):
            try self.configureParameters(bodyParameters: bodyParameters,
                                         bodyEncoding: bodyEncoding,
                                         urlParameters: urlParameters,
                                         request: &request)
        case .requestParametersAndHeaders(let bodyParameters,
                                          let bodyEncoding,
                                          let urlParameters,
                                          let additionalHeaders):
            self.addAdditionalHeaders(additionalHeaders, request: &request)
            try self.configureParameters(bodyParameters: bodyParameters,
                                         bodyEncoding: bodyEncoding,
                                         urlParameters: urlParameters,
                                         request: &request)
        }
        return request
    }

    private func configureParameters(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch {
            throw error
        }
    }

    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?,
                                      request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
