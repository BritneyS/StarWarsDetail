//
//  Planet.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/25/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import Foundation

class Planet: Codable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
