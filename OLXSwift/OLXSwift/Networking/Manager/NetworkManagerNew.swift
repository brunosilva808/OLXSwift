import Foundation

struct NetworkManagerNew {
    var router = RouterNew()
    
    func response(with request: HTTPRequest, onSuccess: @escaping ResponseCallback<String>, onError: @escaping APIErrorCallback, onFinally: @escaping SimpleCallback) {
        
        router.request(with: request) { (data, response, error) in
            if error != nil {
                onError(error?.localizedDescription ?? NetworkResponse.failed.rawValue)
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)

                switch result {
                case .success:
                    guard let data = data else { return }

                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                        onSuccess(string)
                    } else {
                        onError("")
                    }
                case .failure(let failure):
                    onError(failure)
                }
            }

            onFinally()
        }
    }
    
}

extension NetworkManagerNew {
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
