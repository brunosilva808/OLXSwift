//
//  Utils.swift
//  Marvel
//
//  Created by Bruno Silva on 03/12/2018.
//

import Foundation

typealias ResponseArrayCallback<T> = (_ response: T) -> ()
typealias ResponseCallback<T> = (_ response: T) -> ()
typealias APIErrorCallback = (String) -> ()
typealias SimpleCallback = () -> ()
