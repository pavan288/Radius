//
//  ViewController.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 28/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var radiusViewModel: RadiusViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        radiusViewModel = RadiusViewModel()
        radiusViewModel?.fetchRadiusData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

