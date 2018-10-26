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
    let filmURLstring = "https://swapi.co/api/films/2/"
    var personObject: [Person?] = []
    var filteredPersonArray: [Person] = []
    var callCount = 0
    var urlArray: [URL] = []
    
    // MARK: Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        urlArray = populateURLArray()
        getDataFromURLArray(array: urlArray)
    }
    
    // MARK: Methods
    
    func populateURLArray() -> [URL] {
        var pageNumber = 1
        while pageNumber <= 9 {
            guard let peopleURL = URL(string: "https://swapi.co/api/people/?page=\(pageNumber)") else { return urlArray }
            urlArray.append(peopleURL)
            pageNumber += 1
        }
        return urlArray
    }
    
    func getDataFromURLArray(array: [URL]) {
        for url in array {
            getData(from: url)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
}

// MARK: API Call

extension CharacterListViewController {
    
    func parsePersonData(data: Data) -> [Person?] {
        callCount += 1
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PersonArray.self, from: data)
            print("🐱Successful parsing at call \(callCount)")
            return result.results
        } catch {
            print("🚨Error \(error) in JSON parsing for Person data for call \(callCount)")
            return []
        }
    }
    
    /// parse JSON response asynchronously
    
    func getData(from url: URL) {
        let session = URLSession.shared
        performPersonDataTask(session: session, url: url)
    }
    
    func performPersonDataTask(session: URLSession, url: URL) {
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
                        //TODO: Make this: self.isLoading = false
                        //TODO: Write this: self.showNetworkError()
                    }
                    return
                }
                
                ///parse data
                self.personObject = self.parsePersonData(data: data)
                ///work with parsed data
                DispatchQueue.main.async {
                    ///work with data
                    for person in self.personObject {
                        guard let person = person else { return }
                        if person.films.contains(self.filmURLstring) {
                            print("👍Person Object characters: \(person.name)")
                            self.filteredPersonArray.append(person)
                        }
                    }
                   self.characterListTableView.reloadData()
                   print("🃏Total: \(self.filteredPersonArray.count)")
                }
            }
        })
        dataTask.resume()
    }
    
}
