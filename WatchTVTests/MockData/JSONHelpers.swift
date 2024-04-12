//
//  JSONFileReader.swift
//  WatchTVTests
//
//  Created by Tien Pham on 12/4/24.
//

import Foundation

class JSONHelpers {
    static func data(fromJSONFile fileName: String) -> Data? {
        let bundle = Bundle(for: JSONHelpers.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error reading JSON file:", error)
            return nil
        }
    }
}
