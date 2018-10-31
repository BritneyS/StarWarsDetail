//
//  Person.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/25/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import Foundation

class PersonArray: Decodable {
    let results: [Person]
}

class Person: Decodable {
    let name: String
    let birth_year: String
    let gender: String
    let species: [URL]
    let homeworld: URL
    let films: [URL]
    let mass: String
}


