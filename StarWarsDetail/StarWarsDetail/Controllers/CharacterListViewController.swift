//
//  CharacterListViewController.swift
//  StarWarsDetail
//
//  Created by Britney Smith on 10/25/18.
//  Copyright © 2018 Britney Smith. All rights reserved.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var characterListTableView: UITableView!
    
    // MARK: Properties
    let filmURL = URL(string:"https://swapi.co/api/films/2/")
    var personObject: [Person?] = []
    var filteredPersonArray: [Person] = []
    var callCount = 0
    var urlArray: [URL] = []
    var selectedIndex = 0
    
    // MARK: Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        populateCharacterNames()
    }
    
    // MARK: Methods
    
    func populateCharacterNames() {
        urlArray = populateURLArray()
        getCharacterData(from: urlArray)
    }
    
    func populateURLArray() -> [URL] {
        var pageNumber = 1
        while pageNumber <= 9 {
            guard let peopleURL = URL(string: "https://swapi.co/api/people/?page=\(pageNumber)") else { return urlArray }
            urlArray.append(peopleURL)
            pageNumber += 1
        }
        return urlArray
    }
    
    func getCharacterData(from urlArray: [URL]) {
        for url in urlArray {
            performPersonDataTask(with: url)
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Identity.characterListToDetailSegue.segueID:
            guard let characterDetailViewController = segue.destination as? CharacterDetailViewController else { return }
            characterDetailViewController.person = filteredPersonArray[selectedIndex]
        default:
            return
        }
    }
    

}

// MARK: UITableViewDelegate and UITableViewDataSource Implementation

extension CharacterListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPersonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identity.characterCell.cellID, for: indexPath)
        cell.textLabel?.text = filteredPersonArray[indexPath.row].name
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
}

// MARK: API Call

extension CharacterListViewController {
    
    func parsePersonData(data: Data) -> [Person?] {
        callCount += 1
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PersonArray.self, from: data)
            return result.results
        } catch {
            print("🚨Error \(error) in JSON parsing for Person data for call \(callCount)")
            return []
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Uh Oh!", message: "There was an error accessing the Star Wars API. " + " Please try again", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /// parse JSON response asynchronously
    
    func performPersonDataTask(with url: URL) {
        
        let session = URLSession.shared
        
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
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showNetworkError()
                    }
                    return
                }
                
                ///parse data
                self.personObject = self.parsePersonData(data: data)
                ///work with parsed data
                DispatchQueue.main.async {
                    ///work with data
                    for person in self.personObject {
                        guard
                            let person = person,
                            let filmURL = self.filmURL
                        else { return }
                        if person.films.contains(filmURL) {
                            //print("👍Person Object characters: \(person.name)")
                            self.filteredPersonArray.append(person)
                        }
                    }
                   self.characterListTableView.reloadData()
                   //print("🃏Total: \(self.filteredPersonArray.count)")
                }
            }
        })
        dataTask.resume()
    }
    
}
