//
//  Film.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/25/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import Foundation

class Film: Codable {
    let title: String
    let characters: [URL]
    
    init(title: String, characters: [URL]) {
        self.title = title
        self.characters = characters
    }
}
