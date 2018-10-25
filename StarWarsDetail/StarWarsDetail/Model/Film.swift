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
    let characters: [Person]
    
    init(title: String, characters: [Person]) {
        self.title = title
        self.characters = characters
    }
}
