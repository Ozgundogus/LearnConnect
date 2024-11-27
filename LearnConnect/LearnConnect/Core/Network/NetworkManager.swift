import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case invalidResponse
    case apiError(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = NetworkConstants.baseURL
    private let apiKey = NetworkConstants.apiKey
    
    private init() {}
    
    // MARK: - API Methods
    typealias VideoCompletion = (Result<[Video], NetworkError>) -> Void
    typealias CategoryCompletion = (Result<[Category], NetworkError>) -> Void
    
    /// Fetch trending videos
    func fetchTrendingVideos(regionCode: String = "US", maxResults: Int = 10, completion: @escaping VideoCompletion) {
        var components = URLComponents(string: "\(baseURL)\(NetworkConstants.Endpoints.videos)")
        components?.queryItems = [
            URLQueryItem(name: NetworkConstants.QueryParams.part, value: "snippet,statistics"),
            URLQueryItem(name: NetworkConstants.QueryParams.chart, value: "mostPopular"),
            URLQueryItem(name: NetworkConstants.QueryParams.regionCode, value: regionCode),
            URLQueryItem(name: NetworkConstants.QueryParams.maxResults, value: "\(maxResults)"),
            URLQueryItem(name: NetworkConstants.QueryParams.key, value: apiKey)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Fetching videos from URL: \(url)") // Debug için URL'i yazdır
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.apiError(error.localizedDescription)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            print("Video API Response Status Code: \(httpResponse.statusCode)") // Debug için status code'u yazdır
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    if let data = data, let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        completion(.failure(.apiError(errorResponse.error.message)))
                    } else {
                        completion(.failure(.apiError("Status code: \(httpResponse.statusCode)")))
                    }
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(videoResponse.items))
                }
            } catch {
                print("Decoding error: \(error)") // Debug için decode hatasını yazdır
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    /// Fetch video categories
    func fetchVideoCategories(regionCode: String = "US", completion: @escaping CategoryCompletion) {
        var components = URLComponents(string: "\(baseURL)\(NetworkConstants.Endpoints.categories)")
        components?.queryItems = [
            URLQueryItem(name: NetworkConstants.QueryParams.part, value: "snippet"),
            URLQueryItem(name: NetworkConstants.QueryParams.regionCode, value: regionCode),
            URLQueryItem(name: NetworkConstants.QueryParams.key, value: apiKey)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Fetching categories from URL: \(url)") // Debug için URL'i yazdır
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.apiError(error.localizedDescription)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            print("Categories API Response Status Code: \(httpResponse.statusCode)") // Debug için status code'u yazdır
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    if let data = data, let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        completion(.failure(.apiError(errorResponse.error.message)))
                    } else {
                        completion(.failure(.apiError("Status code: \(httpResponse.statusCode)")))
                    }
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let categoryResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(categoryResponse.items))
                }
            } catch {
                print("Decoding error: \(error)") // Debug için decode hatasını yazdır
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    /// Search videos by keyword
    func searchVideos(query: String, categoryId: String? = nil, maxResults: Int = 10, completion: @escaping VideoCompletion) {
        var components = URLComponents(string: "\(baseURL)\(NetworkConstants.Endpoints.search)")
        var queryItems = [
            URLQueryItem(name: NetworkConstants.QueryParams.part, value: "snippet"),
            URLQueryItem(name: NetworkConstants.QueryParams.type, value: "video"),
            URLQueryItem(name: NetworkConstants.QueryParams.maxResults, value: "\(maxResults)"),
            URLQueryItem(name: NetworkConstants.QueryParams.key, value: apiKey)
        ]
        
        // Eğer query boş değilse ekle
        if !query.isEmpty {
            queryItems.append(URLQueryItem(name: NetworkConstants.QueryParams.query, value: query))
        }
        
        // Kategori ID'si varsa ekle
        if let categoryId = categoryId {
            queryItems.append(URLQueryItem(name: NetworkConstants.QueryParams.videoCategoryId, value: categoryId))
            // Kategori araması için relevance yerine date parametresini kullanalım
            queryItems.append(URLQueryItem(name: "order", value: "date"))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Search URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.apiError(error.localizedDescription)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            print("Search API Response Status Code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    if let data = data, let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        completion(.failure(.apiError(errorResponse.error.message)))
                    } else {
                        completion(.failure(.apiError("Status code: \(httpResponse.statusCode)")))
                    }
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let searchResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(searchResponse.items))
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
}

// API Error Response modeli
struct APIErrorResponse: Codable {
    let error: APIError
}

struct APIError: Codable {
    let code: Int
    let message: String
}
