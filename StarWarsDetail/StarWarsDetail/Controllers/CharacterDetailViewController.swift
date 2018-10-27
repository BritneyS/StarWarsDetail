//
//  CharacterDetailViewController.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/26/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var person: Person?
    var personSpecies: [Species] = []
    var personHomeworld: Planet?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🙋‍♀️\(person!.name)")
    }
    

}

// MARK: API Call
extension CharacterDetailViewController {
    
    func getSpeciesURLArray() -> [URL?] {
        guard let person = person else { return [] }
        return person.species
    }
    
    func getHomeWorldURL() -> URL? {
        guard let person = person else { return nil }
        return person.homeworld
    }
    
    func parseSpeciesData(data: Data) -> [Species] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([Species].self, from: data)
            return result
        } catch {
            print("Error in parsing Species data: \(error)")
            return []
        }
    }
    
    func parseHomeworldData(data: Data) -> Planet? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Planet.self, from: data)
            return result
        } catch {
            print("Error in parsing Homeworld data: \(error)")
            return nil
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Uh Oh!", message: "There was an error accessing the Star Wars API. " + " Please try again", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
