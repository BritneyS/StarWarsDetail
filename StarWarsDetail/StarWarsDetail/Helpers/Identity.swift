//
//  Identity.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/25/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import Foundation

enum Identity: String {
    case characterCell
    
    var cellID: String {
        switch self {
        case .characterCell:
            return "characterCell"
        default:
           return ""
        }
    }
}
