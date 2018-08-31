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
    
    func excludeOptions(for indexPathRow: Int) {
        guard let exclusionsArray = (self.radius?.exclusions.map{ $0.map{$0.optionsId} }) else { return }
        guard let options = self.radius?.facilities.flatMap({ $0.options }) else { return }
        
        for option in options {
            option.isEnabled = true
        }
        
        for exclusion in exclusionsArray {
            guard let selected = exclusion.first, let selectedValue = selected, let excluded = exclusion.last,let excludedValue = excluded else { return }
            let option = options.filter{$0.id == excludedValue}
            if indexPathRow == selectedValue {
                option.first?.isEnabled = false
            }
        }
    }
}
