//
//  RadiusViewModel.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 29/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import Foundation

protocol RadiusViewModelDelegate: class {
    func loadTableView()
}

class RadiusViewModel {
    
    var radius: RadiusObject?
    var delegate: RadiusViewModelDelegate?
    
    func fetchRadiusData(fromURL url: String) {
        
        guard let urlString = URL(string: url) else { return }
        URLSession.shared.dataTask(with: urlString) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                if let radiusObject = try? JSONDecoder().decode(RadiusObject.self, from: data) {
                    self.radius = radiusObject
                    self.delegate?.loadTableView()
                }
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
    
}
