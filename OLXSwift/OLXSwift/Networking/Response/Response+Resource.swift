import Foundation

extension Response {

    class Data: Codable {
        let message: String
        let resource: [Resource]
        let status, total: Int
    }
    
    class Resource: Codable {
        let id: Int
        var watched: Bool = false
        let title, description, hash, videoEmbed: String
        let thumbnails: Thumbnails
        
        enum CodingKeys: String, CodingKey {
            case id, title, description, hash
            case videoEmbed = "video_embed"
            case thumbnails
        }
    }
    
    class Thumbnails: Codable {
        let small, medium, large: Large
    }
    
    class Large: Codable {
        let url: String
        let width, height: Int
    }

}

