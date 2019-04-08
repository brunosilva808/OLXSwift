//
//  Request+Login.swift
//  OLXSwift
//
//  Created by Bruno1 on 08/04/2019.
//

import Foundation

extension Request {
    
    struct Login: HTTPRequest {
        var endpoint: HTTPEndpoint { return API.login(username: self.userName, password: self.password) }
        var userName: String
        var password: String
        
        init (userName: String, password: String) {
            self.userName = userName
            self.password = password
        }
        
        private enum CodingKeys: String, CodingKey { case userName = "username", password }
    }
    
//    struct Login: ServiceRequest {
//
//        var endpoint: ServiceEndpoint { return APIEndpoint.login }
//        var excludedHTTPHeaders: [String]? { return [APIConstant.Header.authorization] }
//
//        var userName: String
//        var password: String
//        private var grantType: String? = nil
//
//        init (userName: String, password: String) {
//            self.userName = userName
//            self.password = password
//            self.grantType = "password"
//        }
//
//        private enum CodingKeys: String, CodingKey { case userName = "username", password, grantType }
//    }

}
