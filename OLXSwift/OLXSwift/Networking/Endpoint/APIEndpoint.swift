import Foundation

enum NetworkEnvironment {
    case production
}

public enum API: HTTPEndpoint {
    case postalCode
    
    var info: EndpointInfo {
        switch self {
        case .postalCode:
            return (.get, "codigos_postais/master/data/codigos_postais.csv")
        }
    }
}

extension HTTPRequest {
    var url: String {
        return "\(Configuration.API.url)\(self.endpoint.info.endpoint)"
    }
}

//extension MarvelAPI: HTTPRequest {
//
//    var environmentBaseURL : String {
//        switch NetworkManager.environment {
//        case .production:
//            return "https://gateway.marvel.com:443/v1/public/"
//        }
//    }
//
//    var baseURL: URL {
//        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
//        return url
//    }
//
//
//
//    var headers: HTTPHeaders? {
//        return nil
//    }
//
//}
