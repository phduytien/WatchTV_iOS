//
//  MovieDetailModel.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation

class MovieDetailModel: Codable {
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Float
    let popularity: Float
    let id: Int
    let title: String
    let overview: String
}

