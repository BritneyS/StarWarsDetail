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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🙋‍♀️\(person!.name)")
    }
    

}
