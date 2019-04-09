import Foundation

public enum API: HTTPEndpoint {
    case login(username: String, password: String)
    case videos(page: Int)
    
    var info: EndpointInfo {
        switch self {
        case .login:
            return (.post, "api/authentication/access-token")
        case .videos(let page):
            return (.get, "videos?page=\(page)")
        }
    }
}

extension HTTPRequest {
    var url: String {
        return "\(Configuration.API.url)\(self.endpoint.info.endpoint)"
    }
}
