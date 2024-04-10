//
//  ImageHelper.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import SwiftUI
import Nuke

class ImageHelper {
    static func setupImageForView(_ imageView: UIImageView, url: String?) {
        guard let moviePosterPath = url, let url = URL(string: "https://image.tmdb.org/t/p/w500\(moviePosterPath)") else {
            return
        }
        let request = ImageRequest(url: url, processors: [
            ImageProcessors.RoundedCorners(radius: 16)
        ])
        
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: "MoviePlaceholder"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(named: "MovieFailure"),
            contentModes: .init(
                success: .scaleAspectFit,
                failure: .scaleAspectFit,
                placeholder: .scaleAspectFit
            )
        )
        
        Nuke.loadImage(with: request, options: options, into: imageView)
    }
}
