import Foundation

extension Response {
    
    struct Authentication: Codable {
        
        var accessToken: String
        var tokenType: String
        var refreshToken: String
    }
}
