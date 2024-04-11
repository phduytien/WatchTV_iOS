//
//  NetworkManager.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation

public class NetworkManager {
    
    private let session: URLSession
    private let apiPathV3 = "https://api.themoviedb.org/3"
    private let apiKey = "47aa75b56464da7a186b813a50035cd4"
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        session = URLSession.init(configuration: config)
    }
    
    func fetchTodayTrending(page: Int, completionHandler: @escaping (TodayTrendingResponseModel?) -> Void) {
        guard let url = URL(string: "\(apiPathV3)/trending/movie/day?api_key=\(apiKey)&language=en-US&page=\(page)") else {
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("An Error Occured \(err.localizedDescription)")
                completionHandler(nil)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                completionHandler(nil)
                return
            }
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(TodayTrendingResponseModel.self, from: jsonData)
                    completionHandler(response)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func searchMovies(keyword: String, page: Int, completionHandler: @escaping (SearchMoviesResponseModel?) -> Void) {
        guard let url = URL(string: "\(apiPathV3)/search/movie?query=\(keyword)&include_adult=false&api_key=\(apiKey)&language=en-US&page=\(page)") else {
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("An Error Occured \(err.localizedDescription)")
                completionHandler(nil)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                completionHandler(nil)
                return
            }
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(SearchMoviesResponseModel.self, from: jsonData)
                    completionHandler(response)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func fetchMovieDetail(id: Int, completionHandler: @escaping (MovieDetailModel?) -> Void) {
        guard let url = URL(string: "\(apiPathV3)/movie/\(id)?api_key=\(apiKey)&language=en-US") else {
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("An Error Occured \(err.localizedDescription)")
                completionHandler(nil)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                completionHandler(nil)
                return
            }
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedMovieDetailModel = try decoder.decode(MovieDetailModel.self, from: jsonData)
                    completionHandler(decodedMovieDetailModel)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
