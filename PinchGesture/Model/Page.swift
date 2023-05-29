//
//  Page.swift
//  PinchGesture
//
//  Created by Can Kanbur on 29.05.2023.
//

import Foundation

struct Page : Identifiable {
    let id : Int
    let imageName : String
}

extension Page {
    var thumbnailName : String {
        return "thumb-" + imageName
    }
}
