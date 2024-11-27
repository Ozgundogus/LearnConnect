import Foundation

enum NetworkConstants {
    static let baseURL = "https://youtube.googleapis.com/youtube/v3"
    static let apiKey = "AIzaSyClx6kQhgOf2AMLwGL9aNdY7M0lO2-Qtvo"
    
    enum Endpoints {
        static let videos = "/videos"
        static let categories = "/videoCategories"
        static let search = "/search"
    }
    
    enum QueryParams {
        static let part = "part"
        static let chart = "chart"
        static let regionCode = "regionCode"
        static let maxResults = "maxResults"
        static let key = "key"
        static let query = "q"
        static let type = "type"
        static let videoCategoryId = "videoCategoryId"
    }
}
