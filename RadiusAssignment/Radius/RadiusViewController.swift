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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        radiusViewModel = RadiusViewModel()
        loader.startAnimating()
        radiusViewModel?.parseCoreData()
        self.radiusViewModel?.delegate = self
        self.radiusTableView.addSubview(self.refreshControl)

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
        let cell: RadiusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RadiusCell", for: indexPath) as! RadiusTableViewCell
            cell.radiusCellLabel?.text = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].name
            if let cellId = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].id,
                let facilityId = radiusViewModel?.radius?.facilities[indexPath.section].facilityId {
                cell.id = String(cellId)
                cell.facilityId = facilityId
            }
            if let imageName = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].icon {
                cell.radiusCellImage?.image = UIImage(named: imageName)
            }
        if let shouldDisableCell = radiusViewModel?.radius?.facilities[indexPath.section].options[indexPath.row].isEnabled {
            cell.radiusCellLabel.isEnabled  = shouldDisableCell
            cell.isUserInteractionEnabled = shouldDisableCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tappedCell: RadiusTableViewCell = tableView.cellForRow(at: indexPath) as? RadiusTableViewCell else { return }
        guard let id = Int(tappedCell.id!) else { return }
        radiusViewModel?.excludeOptions(forFacilityId: id)
        
        switch indexPath.section {
        case 0:
            tableView.reloadSections(IndexSet(integersIn: 1...2), with: UITableViewRowAnimation.none)
        case 1:
            tableView.reloadSections(IndexSet(integer: 2), with: UITableViewRowAnimation.none)
        case 2:
            tableView.reloadSections(IndexSet(integer: 2), with: UITableViewRowAnimation.none)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        _ = radiusViewModel?.enableAllOptions()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            for selectedIndexPath in selectedIndexPaths {
                if selectedIndexPath.section == indexPath.section {
                    tableView.deselectRow(at: selectedIndexPath, animated: false)
                }
            }
        }
        return indexPath
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        radiusViewModel?.parseCoreData()
        self.radiusTableView.reloadData()
        refreshControl.endRefreshing()
    }


}

