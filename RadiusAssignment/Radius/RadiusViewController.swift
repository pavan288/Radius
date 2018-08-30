//
//  ViewController.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 28/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import UIKit

class RadiusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RadiusViewModelDelegate {
    
    var radiusViewModel: RadiusViewModel?
    @IBOutlet weak var radiusTableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        radiusViewModel = RadiusViewModel()
        loader.startAnimating()
        radiusViewModel?.fetchRadiusData(fromURL: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db")
        self.radiusViewModel?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTableView() {
        DispatchQueue.main.async {
            self.radiusTableView.reloadData()
            self.loader.stopAnimating()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        if let sectionNumber = radiusViewModel?.getNumberOfSections() {
            numberOfSections = sectionNumber
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if let rowNumber = radiusViewModel?.getNumberOfRows(forSection: section) {
            numberOfRows = rowNumber
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = ""
        if let headerTitle = radiusViewModel?.getSectionHeader(forSection: section) {
            title = headerTitle
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RadiusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RadiusCell", for: indexPath) as! RadiusTableViewCell // ?? UITableViewCell(style: .default, reuseIdentifier: "RadiusCell")
        if indexPath.section == 0 {
            print(indexPath.section)
            cell.radiusCellLabel?.text = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].name
            if let imageName = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].icon {
                cell.radiusCellImage?.image = UIImage(named: imageName)
            }
        } else if indexPath.section == 1 {
            print(indexPath.section)
            cell.radiusCellLabel.text = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].name
            cell.radiusCellImage?.image = nil
        } else {
            print(indexPath.section)
            cell.radiusCellLabel.text = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].name
            cell.radiusCellImage?.image = nil
        }
        return cell
    }


}

