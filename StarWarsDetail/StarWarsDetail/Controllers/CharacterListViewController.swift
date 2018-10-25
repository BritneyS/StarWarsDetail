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
    
    // MARK: Properties
    
    /// URLs
    let filmURLstring = "https://swapi.co/api/films/2/"
    let peopleURL = URL(string: "https://swapi.co/api/people/")
    var filmObject: Film?
    var personObject: [Person?] = []
    
    // MARK: Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(from: peopleURL!)
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

// MARK: API Call

extension CharacterListViewController {
    
    func parsePersonData(data: Data) -> [Person?] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PersonArray.self, from: data)
            return result.results
        } catch {
            print("Error in JSON parsing for Person data")
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
                print("Successful response \(response!) with data: \(data!)")
                
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
                        if (person?.films.contains(self.filmURLstring))! {
                            print("👍Person Object characters: \(person!.name)")
                        }
                    }
                }
            }
        })
        dataTask.resume()
    }
    
}
