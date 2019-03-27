//
//  EndPointType.swift
//  Marvel
//
//  Created by Bruno Silva on 01/12/2018.
//

import Foundation

public typealias EndpointInfo = (method: HTTPMethod, endpoint: String)

protocol HTTPEndpoint {
    var info: EndpointInfo { get }
}

struct Request {}

protocol HTTPRequest: Codable {
    var url: String { get }
    var endpoint: HTTPEndpoint { get }
    var headers: HTTPHeaders? { get }
    var body: [String: Any] { get }
}

extension HTTPRequest {
    
    var body: [String : Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [String: Any]() }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [String: Any]()
    }
    
    var headers: HTTPHeaders? { return [:] }
    
    var debugDescription: String {
        
        var desc = "[\(self.endpoint.info.method.rawValue)] \(self.url)"
        if self.body.count > 0 { desc += "\nBody:" }
        self.body.forEach { desc += "\n\t\($0.key): \($0.value)" }
        return desc
    }
}


