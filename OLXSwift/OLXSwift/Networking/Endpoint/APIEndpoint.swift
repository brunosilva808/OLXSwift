import Foundation

enum NetworkEnvironment {
    case production
}

public enum API: HTTPEndpoint {
    case videos(page: Int)
    
    var info: EndpointInfo {
        switch self {
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
