import Foundation

class RouterNew {
    private var task: URLSessionTask?

    fileprivate func buildRequest(request: HTTPRequest, url: URL) throws -> URLRequest {
        var customRequest = URLRequest(url: url,
                                       cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                       timeoutInterval: APIConstant.Value.timeoutInterval)
        customRequest.httpMethod = request.endpoint.info.method.rawValue
        
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
    
    func addURLQueryItems(request: inout URLRequest, page: Int) {
        let queryItems = [URLQueryItem(name: APIConstant.Parameter.timeStamp, value: APIConstant.Value.timeStamp),
                          URLQueryItem(name: APIConstant.Parameter.apiKey, value: APIConstant.Value.publicKey),
                          URLQueryItem(name: APIConstant.Parameter.limit, value: "\(APIConstant.Value.limit)"),
                          URLQueryItem(name: APIConstant.Parameter.offset, value: "\(APIConstant.Value.limit * page)")]

        if let urlString = request.url?.absoluteString {
            var urlComps = URLComponents(string: urlString)
            urlComps?.queryItems = queryItems
            request.url = urlComps?.url
        }
    }
    
}
