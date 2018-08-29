//
//  RadiusViewModel.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 29/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import Foundation

class RadiusViewModel {
    
    func fetchRadiusData() {
        
        guard let url = URL(string: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db") else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let radiusData = try? JSONDecoder().decode(RadiusObject.self, from: data)
                print(radiusData)
            } catch let error {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
}
