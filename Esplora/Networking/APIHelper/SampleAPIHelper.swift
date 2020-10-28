import Foundation
class SampleAPIHelper {
    func getApiFeed(address:String,completion: @escaping (Result<AddressModel?, APIError>) -> Void) {
        let requestManager = RequestManager()
        let resource = AddressApiResource(address: address)
        guard let request = try? resource.makeRequest() else { return }
        requestManager.fetch(with: request, decode: { json -> AddressModel? in
            guard let model = json as? AddressModel
                else {
                    return nil
            }
            return model
        }, completion: completion)
    }
    
    

}
