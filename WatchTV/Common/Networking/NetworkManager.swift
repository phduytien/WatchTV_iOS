//
//  NetworkManager.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation

class NetworkManager {
    
    private let session: URLSession
    private let apiPathV3 = "https://api.themoviedb.org/3"
    private let apiKey = "47aa75b56464da7a186b813a50035cd4"
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        session = URLSession.init(configuration: config)
    }
    
    func fetchTodayTrending(page: Int, success: @escaping (TodayTrendingResponseModel?) -> Void, failure: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(apiPathV3)/trending/movie/day?api_key=\(apiKey)&language=en-US&page=\(page)") else {
            failure("API url has wrong format")
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Fetch Today Trending Failed. Error: \(err)")
                failure(err.localizedDescription)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Fetch Today Trending Failed. Response has wrong JSON format")
                failure("Response has wrong JSON format!")
                return
            }
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(TodayTrendingResponseModel.self, from: jsonData)
                    success(response)
                } catch {
                    print("Fetch Today Trending Failed. Parsing JSON data error: \(error)")
                    failure("Parsing JSON Data Failed!")
                }
            }
        }
        task.resume()
    }
    
    func searchMovies(keyword: String, page: Int, success: @escaping (SearchMoviesResponseModel?) -> Void, failure: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(apiPathV3)/search/movie?query=\(keyword)&include_adult=false&api_key=\(apiKey)&language=en-US&page=\(page)") else {
            failure("API url has wrong format")
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Search Movies Failed. Error: \(err)")
                failure(err.localizedDescription)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Search Movies Failed. Response has wrong JSON format")
                failure("Response has wrong JSON format!")
                return
            }
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(SearchMoviesResponseModel.self, from: jsonData)
                    success(response)
                } catch {
                    print("Search Movies Failed. Parsing JSON data error: \(error)")
                    failure("Parsing JSON Data Failed!")
                }
            }
        }
        task.resume()
    }
    
    func fetchMovieDetail(id: Int, success: @escaping (MovieDetailModel?) -> Void, failure: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(apiPathV3)/movie/\(id)?api_key=\(apiKey)&language=en-US") else {
            failure("API url has wrong format")
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Fetch Movie Id: \(id) Detail Failed. Error: \(err)")
                failure(err.localizedDescription)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Fetch Movie Id: \(id) Detail Failed. Response has wrong JSON format")
                failure("Response has wrong JSON format!")
                return
            }
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedMovieDetailModel = try decoder.decode(MovieDetailModel.self, from: jsonData)
                    success(decodedMovieDetailModel)
                } catch {
                    print("Fetch Movie Id: \(id) Detail Failed. Parsing JSON data error: \(error)")
                    failure("Parsing JSON Data Failed!")
                }
            }
        }
        task.resume()
    }
}
