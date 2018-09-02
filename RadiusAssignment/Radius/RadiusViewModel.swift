//
//  RadiusViewModel.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 29/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol RadiusViewModelDelegate: class {
    func loadTableView()
}

class RadiusViewModel {
    
    var radius: RadiusObject?
    var delegate: RadiusViewModelDelegate?
    
    var coreDataRadius: [NSManagedObject]?
    
    func fetchRadiusData(fromURL url: String) {
        
        guard let urlString = URL(string: url) else { return }
        URLSession.shared.dataTask(with: urlString) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                self.radius = try JSONDecoder().decode(RadiusObject.self, from: data)
                self.delegate?.loadTableView()
            } catch let error {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func getNumberOfSections() -> Int? {
        return self.radius?.facilities.count
    }
    
    func getNumberOfRows(forSection section: Int) -> Int? {
        return self.radius?.facilities[section].options.count
    }
    
    func getSectionHeader(forSection section: Int) -> String? {
        return self.radius?.facilities[section].name
    }
    
    func excludeOptions(forFacilityId facilityID: Int) {
        guard let exclusionsArray = (self.radius?.exclusions.map{ $0.map{$0.optionsId} }) else { return }
        guard let options = self.radius?.facilities.flatMap({ $0.options }) else { return }
        
        for option in options {
            option.isEnabled = true
        }
        
        for exclusion in exclusionsArray {
            if exclusion.first! == facilityID {
                let option = options.filter{$0.id == exclusion.last!}
                option.first?.isEnabled = false
            }
        }
    }
}

extension RadiusViewModel {
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getManagedObject(forEntity entityString: String, withContext context: NSManagedObjectContext) -> NSManagedObject? {
        return NSEntityDescription.insertNewObject(forEntityName: entityString, into: context)
    }
    
    func save(object radius:String) -> Bool {
        let context = getContext()
        if let jsonManagedObject = getManagedObject(forEntity: "Json", withContext: context) {
            jsonManagedObject.setValue(radius, forKey: "jsonString")
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        return false
    }
}
