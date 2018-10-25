//
//  Person.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/25/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import Foundation

class Person: Codable {
    let name: String
    let birth_year: String
    let gender: String
    let species: [String]
    let homeworld: String
    
    init(name: String, birth_year: String, gender: String, species: [String], homeworld: String) {
        self.name = name
        self.birth_year = birth_year
        self.gender = gender
        self.species = species
        self.homeworld = homeworld
    }
}
