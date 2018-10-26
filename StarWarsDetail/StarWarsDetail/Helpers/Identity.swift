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
    
    case characterListToDetailSegue
    
    var cellID: String {
        switch self {
        case .characterCell:
            return "characterCell"
        default:
           return ""
        }
    }
    
    var segueID: String {
        switch self {
        case .characterListToDetailSegue:
            return "characterListToDetail"
        default:
            return ""
        }
    }
}
