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
    fileprivate var context: NSManagedObjectContext?
    fileprivate var coreDataRadius: [NSManagedObject]?
    var refreshRequired: Bool = true
    var lastRefreshDate: Date?
    var currentDate: Date {
        return Date()
    }
    
    func fetchRadiusData(fromURL url: String) {
        guard let urlString = URL(string: url) else { return }
        let context = getContext()
        URLSession.shared.dataTask(with: urlString) { (data, response
            , error) in
            guard let data = data else { return }
            guard let responseString = String(data: data, encoding: .utf8) else { return }
            self.lastRefreshDate = self.currentDate
            _ = self.save(radius: responseString, inObject: "Json", inContext: context)
            self.coreDataRadius = self.fetch(object: "Json", fromContext: context)!
            self.populateModel()
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
        let options = self.enableAllOptions()
        
        for exclusion in exclusionsArray {
            if exclusion.first! == facilityID {
                if let option = options?.filter({$0.id == exclusion.last!}) {
                    option.first?.isEnabled = false
                }
            }
        }
    }
    
    func enableAllOptions() -> [Option]? {
        guard let options = self.radius?.facilities.flatMap({ $0.options }) else { return nil }
        for option in options {
            option.isEnabled = true
        }
        return options
    }
    
    func parseCoreData() {
        if let lastdate = self.lastRefreshDate {
            refreshRequired = self.checkIfRefreshRequired(date1: currentDate, date2: lastdate)
        }
        if refreshRequired {
            self.fetchRadiusData(fromURL: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db")
        } else {
            self.populateModel()
        }
    }
    
    func populateModel() {
        if let localJsonString = self.coreDataRadius?.first?.value(forKey: "jsonString") as? String,
            let localData = localJsonString.data(using: .utf8) {
            do {
                self.radius = try JSONDecoder().decode(RadiusObject.self, from: localData)
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
        self.delegate?.loadTableView()
        self.refreshRequired = false
    }
    
    func checkIfRefreshRequired(date1: Date, date2: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let datesAreInTheSameDay = calendar.isDate(date1, equalTo: date2, toGranularity:.day)

        return !datesAreInTheSameDay
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
    
    func save(radius:String, inObject object: String, inContext context: NSManagedObjectContext) -> Bool {
        
        //replace existing response
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Json")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
        if let jsonManagedObject = getManagedObject(forEntity: object, withContext: context) {
            jsonManagedObject.setValue(radius, forKey: "jsonString")
            do {
                try context.save()
                return true
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        return false
    }
    
    func fetch(object radius: String, fromContext context: NSManagedObjectContext) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSManagedObject>(entityName: radius)
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            return results
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
