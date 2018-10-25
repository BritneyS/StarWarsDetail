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
    let filmURL = URL(string: "https://swapi.co/api/films/2")
    var filmObject: Film?
    var personObject: Person?
    
    // MARK: Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(from: filmURL!)
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
    
    /// get urls
    /// films/2 ✅
    /// people ([])
    /// species ([])
    /// planets
    
    func parseFilmData(data: Data) -> Film? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Film.self, from: data)
            return result
        } catch {
            print("Error in JSON parsing")
            return nil
        }
    }
    
    /// parse JSON response asynchronously
    
    func getData(from url: URL) {
        let session = URLSession.shared
        performFilmDataTask(session: session, url: url)
        let personURLArray = filmObject?.characters
        
        for url in personURLArray! {
            //performPersonDataTask(session: session, url: url)
        }
    }
    
    func performPersonDataTask(
    
    func performFilmDataTask(session: URLSession, url: URL) {
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
                        //self.isLoading = false
                        //self.showNetworkError()
                    }
                    return
                }
                
                ///parse data
                self.filmObject = self.parseFilmData(data: data)
                ///work with parsed data
                DispatchQueue.main.async {
                    ///work with data
                    for person in (self.filmObject?.characters)! {
                    print("Film Object characters: \(person)")
                        
                    
                    }
                }
            }
        })
        dataTask.resume()
    }
    
}
