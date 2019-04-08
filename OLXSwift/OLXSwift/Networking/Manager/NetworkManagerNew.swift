import Foundation

struct NetworkManagerNew {
    var router = RouterNew()
    
    func response<T: Codable>(with request: HTTPRequest, onSuccess: @escaping ResponseCallback<[T]>, onError: @escaping APIErrorCallback, onFinally: @escaping SimpleCallback) {
        
        router.request(with: request) { (data, response, error) in
            if error != nil {
                onError(error?.localizedDescription ?? NetworkResponse.failed.rawValue)
            }
            
            if let originalResponse = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(originalResponse)
                
                switch result {
                case .success:
                    guard let data = data else { return }
                    
                    if let result = try? JSONDecoder().decode([T].self, from: data) {
                        onSuccess(result)
                    } else {
                        onError(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let failure):
                    if originalResponse.statusCode == 401 {
                        onError(failure)
                    } else {
                        onError(failure)
                    }
                }
            }
            
            onFinally()
        }
    }
    
    func response<T: Codable>(with request: HTTPRequest, onSuccess: @escaping ResponseCallback<T>, onError: @escaping APIErrorCallback, onFinally: @escaping SimpleCallback) {
        
        router.request(with: request) { (data, response, error) in
            if error != nil {
                onError(error?.localizedDescription ?? NetworkResponse.failed.rawValue)
            }

            if let originalResponse = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(originalResponse)
                
                switch result {
                case .success:
                    guard let data = data else { return }

                    if let result = try? JSONDecoder().decode(T.self, from: data) {
                        onSuccess(result)
                    } else {
                        onError(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let failure):
                    if originalResponse.statusCode == 401 {
                        let wrappedRequestCallback = {
                            NetworkManagerNew().response(with: request, onSuccess: onSuccess, onError: onError, onFinally: onFinally)
                        }
                        
                        NetworkManagerNew.checkSpecificErrorStates(request: request, wrappedRequest: wrappedRequestCallback, onError: onError)
                    } else {
                        onError(failure)
                    }
                }
            }
            
            onFinally()
        }
    }
    
    // This method needs to have an array of callbacks like in alamofire documentation because it has a bug
    private static func checkSpecificErrorStates(request: HTTPRequest, wrappedRequest: @escaping SimpleCallback, onError: @escaping APIErrorCallback) {
    
        //Request.Login -> Replace with Request.RenewToken
        guard !(request is Request.Login) else {
//            NotificationManager.shared.notify(event: Config.Listener.sessionExpiredEvent, argument: true)
            return
        }
        
        NetworkManagerNew().response(with: Request.Login(userName: "user", password: "pass"), onSuccess: { (response: Response.Resource) in
            wrappedRequest()
        }, onError: { (error) in
            onError(error)
        }) {}
        
//            if (WSManager.sharedInstance.token.refreshToken == nil) {
//
//                Service.sharedInstance.login(with: WSManager.sharedInstance.username, and: WSManager.sharedInstance.password, successBlock: {
//                    if var request = request {
//                        request.setValue(WSManager.sharedInstance.getApiToken(), forHTTPHeaderField: APIHeaders.authorizationKey)
//                        repeatRequestCallback(request)
//                    } else {
//                        originalCallback()
//                    }
//                }) { (error) in
//                    originalCallback()
//                }
//            } else {
//                Service.sharedInstance.refreshToken(successBlock: {
//                    if var request = request {
//                        request.setValue(WSManager.sharedInstance.getApiToken(), forHTTPHeaderField: APIHeaders.authorizationKey)
//                        repeatRequestCallback(request)
//                    } else {
//                        originalCallback()
//                    }
//                }, errorBlock: {_ in
//                    WSManager.sharedInstance.logout(successBlock: {
//                        // Show login screen
//                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//                        appDelegate?.logout()
//                    })
//                    originalCallback()
//                })
//            }
    }
    
}
