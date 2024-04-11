//
//  SearchMoviesResponseModel.swift
//  WatchTV
//
//  Created by Tien Pham on 11/4/24.
//

import Foundation

class SearchMoviesResponseModel: Decodable {
    let page: Int
    let results: [MovieItemModel]
    let totalPages: Int
    let totalResults: Int
}
