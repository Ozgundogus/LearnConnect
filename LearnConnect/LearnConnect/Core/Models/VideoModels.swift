import Foundation

// MARK: - Video Response
struct VideoResponse: Codable {
    let items: [Video]
    let nextPageToken: String?
}

// MARK: - Video
struct Video: Codable {
    let id: VideoID
    let snippet: VideoSnippet
    let statistics: VideoStatistics?
    
    enum CodingKeys: String, CodingKey {
        case id, snippet, statistics
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // ID'yi string veya dictionary olarak decode et
        if let stringID = try? container.decode(String.self, forKey: .id) {
            self.id = VideoID(videoId: stringID)
        } else {
            self.id = try container.decode(VideoID.self, forKey: .id)
        }
        
        self.snippet = try container.decode(VideoSnippet.self, forKey: .snippet)
        self.statistics = try? container.decodeIfPresent(VideoStatistics.self, forKey: .statistics)
    }
}

// MARK: - Video ID
struct VideoID: Codable {
    let videoId: String
    
    enum CodingKeys: String, CodingKey {
        case videoId = "videoId"
    }
    
    init(videoId: String) {
        self.videoId = videoId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.videoId = try container.decode(String.self, forKey: .videoId)
    }
}

// MARK: - Video Snippet
struct VideoSnippet: Codable {
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let publishedAt: String
    let categoryId: String?
}

// MARK: - Video Statistics
struct VideoStatistics: Codable {
    let viewCount: String?
    let likeCount: String?
    let commentCount: String?
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let medium: ThumbnailInfo
    let high: ThumbnailInfo
}

// MARK: - Thumbnail Info
struct ThumbnailInfo: Codable {
    let url: String
    let width: Int
    let height: Int
}

// MARK: - Category Response
struct CategoryResponse: Codable {
    let items: [Category]
}

// MARK: - Category
struct Category: Codable {
    let id: String
    let snippet: CategorySnippet
}

// MARK: - Category Snippet
struct CategorySnippet: Codable {
    let title: String
} 
