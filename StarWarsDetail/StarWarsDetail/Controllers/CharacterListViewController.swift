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
    
    /// URLs
    let filmURLstring = "https://swapi.co/api/films/2/"
    let peopleURLOne = URL(string: "https://swapi.co/api/people/?page=1") /// TODO: Add multiple pages
    let peopleURLTwo = URL(string: "https://swapi.co/api/people/?page=2")
    let peopleURLThree = URL(string: "https://swapi.co/api/people/?page=3")
    let peopleURLFour = URL(string: "https://swapi.co/api/people/?page=4")
    let peopleURLFive = URL(string: "https://swapi.co/api/people/?page=5")
    let peopleURLSix = URL(string: "https://swapi.co/api/people/?page=6")
    let peopleURLSeven = URL(string: "https://swapi.co/api/people/?page=7")
    let peopleURLEight = URL(string: "https://swapi.co/api/people/?page=8")
    let peopleURLNine = URL(string: "https://swapi.co/api/people/?page=9")
    var filmObject: Film?
    var personObject: [Person?] = []
    var filteredPersonArray: [Person] = []
    var callCount = 0
    
    // MARK: Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlArray = [peopleURLOne, peopleURLTwo, peopleURLThree, peopleURLFour, peopleURLFive, peopleURLSix, peopleURLSeven, peopleURLEight, peopleURLNine]
        
        for url in urlArray {
            guard let url = url else { return }
            getData(from: url)
            //callCount += 1
            //print("Call count: \(callCount)")
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
                            //print("💻Person Array next: \()")
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
