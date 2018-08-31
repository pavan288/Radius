//
//  RadiusDataModel.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 29/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import Foundation

class RadiusDataModel: NSObject, Decodable {
    var object: RadiusObject?
}

class RadiusObject:  Decodable {
    var facilities: [RadiusFacility]
    var exclusions: [[RadiusExclusion]]
    
    enum CodingKeys: String, CodingKey {
        case facilities
        case exclusions
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.facilities = try codingValues.decode([RadiusFacility].self, forKey: .facilities)
        self.exclusions = try codingValues.decode([[RadiusExclusion]].self, forKey: .exclusions)
    }
}

class RadiusFacility: NSObject, Decodable {
    var facilityId: String
    var name: String
    var options: [Option]
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case name
        case options
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.facilityId = try codingValues.decode(String.self, forKey: .facilityId)
        self.name = try codingValues.decode(String.self, forKey: .name)
        self.options = try codingValues.decode([Option].self, forKey: .options)
    }
}

class Option: NSObject, Codable {
    var name: String
    var icon: String?
    var id: Int?
    var isEnabled: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case name
        case icon
        case id
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try codingValues.decode(String.self, forKey: .name)
        self.icon = try? codingValues.decode(String.self, forKey: .icon)
        if let id = try? codingValues.decode(String.self, forKey: .id) {
            self.id = Int(id)
        }
    }
}

class RadiusExclusion: NSObject, Decodable {
    var facilityId: Int?
    var optionsId: Int?
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case optionsId = "options_id"
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        if let facilityID = try? codingValues.decode(String.self, forKey: .facilityId) {
            self.facilityId = Int(facilityID)
        }
        if let optionID = try? codingValues.decode(String.self, forKey: .optionsId) {
            self.optionsId = Int(optionID)
        }
    }
}
