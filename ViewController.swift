//
//  ViewController.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 05/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dataProvider = DataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataProvider.getMovies { (movies : Result<[Movie],Error>) in
            print(movies)
        }
    }


}

