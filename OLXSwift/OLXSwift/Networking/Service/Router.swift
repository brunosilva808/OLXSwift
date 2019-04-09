import Foundation

class Router {
    private var task: URLSessionTask?
    var authentication: Response.Authentication?
    
    func purge() {
        self.authentication = nil
    }
    
    fileprivate func buildRequest(request: HTTPRequest, url: URL) throws -> URLRequest {
        var customRequest = URLRequest(url: url,
                                       cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                       timeoutInterval: APIConstant.Value.timeoutInterval)
        customRequest.httpMethod = request.endpoint.info.method.rawValue
        self.addURLQueryItems(request: &customRequest)
        
        if !request.body.isEmpty {
            do {
                try JSONParameterEncoder.encode(urlRequest: &customRequest, with: request.body)
            } catch {
                throw error
            }
        }
        
        return customRequest
    }
    
    func request(with request: HTTPRequest, completion: @escaping NetworkRouterCompletion) {
        guard let url = URL(string: request.url) else { return }
        
        do {
            let customRequest = try self.buildRequest(request: request, url: url)
            print(request.debugDescription)
            let session = URLSession.shared
            self.task = session.dataTask(with: customRequest, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
            self.task?.resume()
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func addURLQueryItems(request: inout URLRequest) {
        let queryItems = [URLQueryItem(name: HeaderConstant.type.token,
                                       value: HeaderConstant.value.token)]
        
        if let urlString = request.url?.absoluteString {
            var urlComps = URLComponents(string: urlString)
            urlComps?.queryItems?.append(contentsOf: queryItems)
            request.url = urlComps?.url
        }
    }

}
