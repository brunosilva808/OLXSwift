//
//  Configuration.swift
//  Marvel
//
//  Created by Bruno Silva on 08/01/2019.
//

import Foundation

public final class Configuration {
    
    public private(set) static var shared = Configuration()
    public var configurationName: String = "OLXSwift"
    
    private lazy var configurations: [String : Any] = {
        if let configurationsData = Bundle.main.infoDictionary?[self.configurationName] as? [String: Any] {
            return configurationsData
        } else {
            print("Info.plist does not contain configuration key [\(self.configurationName)].")
            return  [:]
        }
    }()
    public static func urlFor(key: String) -> URL { return URL(string: Configuration.shared.configurations[key] as! String) ?? URL(string: "/")! }
    
    enum API {
        static var url: URL = { return Configuration.urlFor(key: "APIURL") }()
    }
    
    enum Website {
        static var url: URL = { return Configuration.urlFor(key: "WebsiteURL") }()
    }
}
