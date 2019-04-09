import Foundation

extension NetworkManager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> HTTPResult<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum HTTPResult<String>{
    case success
    case failure(String)
}



//public enum ServiceError: Error {
//    
//    case generic(Error)
//    
//    case httpResponseNotOK(code: Int, message: String?, error: String?)
//    case noInternetConnection
//    case mandatoryAttributeNotFound(attribute: String)
//    case unexpectedResponseFormat(format: String)
//    case custom(error: Error?, description: String?)
//    
//    var debugDescription: String {
//        
//        switch self {
//        case .generic(let error): return "Generic error occured. Wrapped error description: \(error.localizedDescription)"
//        case .noInternetConnection: return "Internet connection is not active."
//        case .unexpectedResponseFormat(let expectedFormat): return "Expected response format is \(expectedFormat), but something else was found."
//        case .mandatoryAttributeNotFound(let field): return "Tried to parse data, but mandatory field \(field) was not found."
//        case .httpResponseNotOK(let statusCode, let description, let error):
//            var message = "Response status code was: \(statusCode)"
//            if let description = description { message += "\nDescription: \(description)" }
//            if let error = error { message += "\nService Response: \(error)" }
//            return message
//        case .custom(let error, let description):
//            var message = "Custom Error Description"
//            if let error = error { message += "\n" + error.localizedDescription }
//            if let description = description { message += "\n" + description }
//            return message
//        }
//    }
//}
