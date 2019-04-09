import Foundation

class NetworkManager {
    private var router = Router()
    private var isRefreshing = false
    private var lock = NSLock()
    private var requestsToRetry: [SimpleCallback] = []
    
    func response<T: Codable>(with request: HTTPRequest, onSuccess: @escaping ResponseCallback<[T]>, onError: @escaping APIErrorCallback, onFinally: @escaping SimpleCallback) {
        
        router.request(with: request) { [weak self] (data, response, error) in
            if error != nil {
                onError(error?.localizedDescription ?? NetworkResponse.failed.rawValue)
            }
            
            if let originalResponse = response as? HTTPURLResponse {
                let result = self?.handleNetworkResponse(originalResponse)
                
                switch result {
                case .success?:
                    guard let data = data else { return }
                    
                    if let result = try? JSONDecoder().decode([T].self, from: data) {
                        onSuccess(result)
                    } else {
                        onError(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let failure)?:
                    if originalResponse.statusCode == 401 {
                        let wrappedRequestCallback = {
                            NetworkManager().response(with: request, onSuccess: onSuccess, onError: onError, onFinally: onFinally)
                        }
                        
                        self?.checkSpecificErrorStates(request: request, wrappedRequest: wrappedRequestCallback, onError: onError, error: error as! String)
                    } else {
                        onError(failure)
                    }
                case .none:
                    break
                }
            }
            
            onFinally()
        }
    }
    
    func response<T: Codable>(with request: HTTPRequest, onSuccess: @escaping ResponseCallback<T>, onError: @escaping APIErrorCallback, onFinally: @escaping SimpleCallback) {

        router.request(with: request) { [weak self] (data, response, error) in
            if error != nil {
                onError(error?.localizedDescription ?? NetworkResponse.failed.rawValue)
            }

            if let originalResponse = response as? HTTPURLResponse {
                let result = self?.handleNetworkResponse(originalResponse)
                
                switch result {
                case .success?:
                    guard let data = data else { return }

                    if let result = try? JSONDecoder().decode(T.self, from: data) {
                        onSuccess(result)
                    } else {
                        onError(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let failure)?:
                    if originalResponse.statusCode == 401 {
                        let wrappedRequestCallback = {
                            NetworkManager().response(with: request, onSuccess: onSuccess, onError: onError, onFinally: onFinally)
                        }
                        
                        self?.checkSpecificErrorStates(request: request, wrappedRequest: wrappedRequestCallback, onError: onError, error: error as! String)
                    } else {
                        onError(failure)
                    }
                case .none:
                    break
                }
            }
            
            onFinally()
        }
    }
    
    // TODO: This function was not tested
    // This method needs to have an array of callbacks like in alamofire documentation because it has a bug https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md
    // This method is called when httpCode = 401, it should be called for all codes
    private func checkSpecificErrorStates(request: HTTPRequest, wrappedRequest: @escaping SimpleCallback, onError: @escaping APIErrorCallback, error: String) {
    
        lock.lock() ; defer { lock.unlock() }
        
        //Request.Login -> Replace with Request.RenewToken
        if !(request is Request.Login) && self.isRefreshing {
            self.requestsToRetry.append(wrappedRequest)
        } else if (request is Request.Login) {
            //logout -> Request.Login = 401
        } else if !self.isRefreshing {
            self.isRefreshing = true
        
            // Instead of the Request.Login -> Replace with Request.RenewToken, check if RenewToken call should only be here??
            NetworkManager().response(with: Request.Login(userName: "user", password: "pass"), onSuccess: { [weak self] (response: Response.Authentication) in
                
                self?.lock.lock() ; defer { self?.lock.unlock() }
                
                // Saves token in... the authentication logic needs to be rethinked because it is not being used at the moment
                self?.router.authentication = response
                self?.isRefreshing = false
                
                wrappedRequest()
                
                self?.requestsToRetry.forEach { $0() }
                self?.requestsToRetry.removeAll()
            }, onError: { (error) in
                onError(error)
            }) {}
        } else {
            onError(error)
        }
    }
    
}
