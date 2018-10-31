//
//  CharacterDetailViewController.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/26/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var homeworldLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    // MARK: Properties
    
    var person: Person?
    var personSpeciesObject: Species?
    var personSpeciesArray: [Species] = []
    var personHomeworldObject: Planet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSpeciesData()
        getHomeworldData()
        populatePersonLabels()
    }
    
    // MARK: Methods
    
    func getSpeciesData() {
        let speciesURLArray = getSpeciesURLArray()
        for url in speciesURLArray {
            guard let url = url else { return }
            performSpeciesDataTask(with: url)
        }
    }
    
    func getHomeworldData() {
        guard let homeworldURL = getHomeWorldURL() else { return }
        performHomeworldDataTask(with: homeworldURL)
    }
    
    func populatePersonSpeciesArray(species: Species?) {
        guard let species = species else { return }
        personSpeciesArray.append(species)
    }
    
    func populateSpeciesLabel() {
        for species in personSpeciesArray {
            if personSpeciesArray.count == 1 {
                speciesLabel.text = species.name
            } else {
                var speciesString = ""
                speciesString += "\(species.name) \n"
                speciesLabel.text = speciesString
            }
        }
    }
    
    func populateHomeworldLabel() {
        guard let personHomeworldObject = personHomeworldObject else { return }
        homeworldLabel.text = personHomeworldObject.name
    }
    
    func populateNameLabel(from person: Person) {
        nameLabel.text = person.name
    }
    
    func populateBirthYearLabel(from person: Person) {
        birthYearLabel.text = person.birth_year
    }
    
    func populateGenderLabel(from person: Person) {
        genderLabel.text = person.gender
    }
    
    func populateMassLabel(from person: Person) {
        massLabel.text = person.mass
    }
    
    func populatePersonLabels() {
        guard let person = person else { return }
        populateNameLabel(from: person)
        populateBirthYearLabel(from: person)
        populateGenderLabel(from: person)
        populateMassLabel(from: person)
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
    
    func parseSpeciesData(data: Data) -> Species? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Species.self, from: data)
            return result
        } catch {
            print("Error in parsing Species data: \(error)")
            return nil
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
    
    func performSpeciesDataTask(with url: URL) {
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print(error)
            } else { ///Successful call
                ///confirming response
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Bad response: \(response!) \n Error: \(error!)")
                    return
                }
                ///successful response
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showNetworkError()
                    }
                    return
                }
                
                ///parse data
                self.personSpeciesObject = self.parseSpeciesData(data: data)
                ///work with parsed data
                DispatchQueue.main.async {
                    ///work with species data
                    self.populatePersonSpeciesArray(species: self.personSpeciesObject)
                    self.populateSpeciesLabel()
                }
            }
        })
        dataTask.resume()
    }
    
    func performHomeworldDataTask(with url: URL) {
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print(error)
            } else { ///Successful call
                ///confirming response
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Bad response: \(response!) \n Error: \(error!)")
                    return
                }
                ///successful response
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showNetworkError()
                    }
                    return
                }
                
                ///parse data
                self.personHomeworldObject = self.parseHomeworldData(data: data)
                ///work with parsed data
                DispatchQueue.main.async {
                    ///work with homeworld data
                    self.populateHomeworldLabel()
                }
            }
        })
        dataTask.resume()
    }
}
