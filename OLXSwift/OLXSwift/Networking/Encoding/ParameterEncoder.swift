//
//  ParameterEncoding.swift
//  Marvel
//
//  Created by Bruno Silva on 01/12/2018.
//

import Foundation

enum HeaderConstant {
    struct type {
        static let contentType = "Content-Type"
        static let token = "olx-token"
        static let page = "page"
    }
    struct value {
        static let urlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
        static let applicationJson = "application/json"
        static let token = "96f58b5dd2b07b3b54e9d848f58edb3e87cd3a19"
    }
}

public typealias Parameters = [String: Any]

protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {}

public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
