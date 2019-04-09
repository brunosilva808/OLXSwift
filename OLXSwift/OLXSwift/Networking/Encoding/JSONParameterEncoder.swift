//
//  JSONParameterEncoder.swift
//  Marvel
//
//  Created by Bruno Silva on 01/12/2018.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: APIConstant.Header.contentType) == nil {
                urlRequest.setValue(APIConstant.Value.applicationJson,
                                    forHTTPHeaderField: APIConstant.Header.contentType)
            }
        } catch  {
            throw NetworkError.encodingFailed
        }
    }
}
