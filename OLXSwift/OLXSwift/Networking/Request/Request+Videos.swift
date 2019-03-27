//
//  Character.swift
//  Marvel
//
//  Created by Bruno Silva on 07/01/2019.
//

import Foundation

extension Request {

    struct Videos: HTTPRequest {
        var endpoint: HTTPEndpoint { return API.videos(page: self.page) }
        var page: Int = 1
        var body: [String : Any] { return [:] }
    }
}


