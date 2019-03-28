import Foundation

extension Response {

    struct Data: Codable {
        let message: String
        let resource: [Resource]
        let status, total: Int
    }
    
    struct Resource: Codable {
        let id: Int
        let title, description, hash, videoEmbed: String
        let thumbnails: Thumbnails
        
        enum CodingKeys: String, CodingKey {
            case id, title, description, hash
            case videoEmbed = "video_embed"
            case thumbnails
        }
    }
    
    struct Thumbnails: Codable {
        let small, medium, large: Large
    }
    
    struct Large: Codable {
        let url: String
        let width, height: Int
    }

}

