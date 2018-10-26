//
//  Person.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/25/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import Foundation

class PersonArray: Codable {
    let count: Int
    let results: [Person]
}

class Person: Codable {
    let name: String
    let birth_year: String
    let gender: String
    let species: [String]
    let homeworld: String
    let films: [String]
}


