import Foundation

enum NetworkEnvironment {
    case production
}

public enum API: HTTPEndpoint {
    case videos
    
    var info: EndpointInfo {
        switch self {
        case .videos:
            return (.get, "videos")
        }
    }
}

extension HTTPRequest {
    var url: String {
        return "\(Configuration.API.url)\(self.endpoint.info.endpoint)"
    }
}
