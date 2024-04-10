//
//  UIFont+Helper.swift
//  WatchTV
//
//  Created by Tien Pham on 10/4/24.
//

import Foundation
import SwiftUI

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        // Size 0 means keep the size as it is
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
