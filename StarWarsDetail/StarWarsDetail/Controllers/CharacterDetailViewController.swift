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
    var personSpeciesObject: Species?
    var personSpeciesArray: [Species] = []
    var personHomeworldObject: Planet?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🙋‍♀️\(person!.name)")
        speciesDataHandling()
        homeworldDataHandling()
    }
    
    // MARK: Methods
    
    func speciesDataHandling() {
        let speciesURLArray = getSpeciesURLArray()
        for url in speciesURLArray {
            guard let url = url else { return }
            getSpeciesData(from: url)
        }
    }
    
    func homeworldDataHandling() {
        guard let homeworldURL = getHomeWorldURL() else { return }
        getHomeworldData(from: homeworldURL)
    }
    
    func getSpeciesData(from url: URL) {
        let session = URLSession.shared
        performSpeciesDataTask(session: session, url: url)
    }
    
    func getHomeworldData(from url: URL) {
        let session = URLSession.shared
        performHomeworldDataTask(session: session, url: url)
    }
    
    func appendPersonSpecies(species: Species?) {
        guard let species = species else { return }
        personSpeciesArray.append(species)
    }
    
    func populateSpeciesLabel() {
        for species in personSpeciesArray {
            print("Species: \(species.name)")
        }
    }
    
    func populateHomeworldLabel() {
        guard let personHomeworldObject = personHomeworldObject else { return }
        print("Homeworld: \(personHomeworldObject.name)")
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
    
    func performSpeciesDataTask(session: URLSession, url: URL) {
        let dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print(error)
            } else { ///Successful call
                ///confirming response
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Bad response: \(response!)")
                    return
                }
                ///successful response
                print("✅Successful response \(response!) at 🦊 \(url) with data: \(data!)")
                
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
                    ///work with speciesdata
                    self.appendPersonSpecies(species: self.personSpeciesObject)
                    self.populateSpeciesLabel()
                }
            }
        })
        dataTask.resume()
    }
    
    func performHomeworldDataTask(session: URLSession, url: URL) {
        let dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print(error)
            } else { ///Successful call
                ///confirming response
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Bad response: \(response!)")
                    return
                }
                ///successful response
                print("✅Successful response \(response!) at 🦊 \(url) with data: \(data!)")
                
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
                    ///work with speciesdata
                    self.populateHomeworldLabel()
                }
            }
        })
        dataTask.resume()
    }
}
