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
    let species: [Species]
    let homeworld: Planet
    
    init(name: String, birth_year: String, gender: String, species: [Species], homeworld: Planet) {
        self.name = name
        self.birth_year = birth_year
        self.gender = gender
        self.species = species
        self.homeworld = homeworld
    }
}
