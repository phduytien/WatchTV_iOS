//
//  TodayTrendingReponseModel.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation

class TodayTrendingResponseModel: Decodable {
    let page: Int
    let results: [MovieItemModel]
    let totalPages: Int
    let totalResults: Int
}
