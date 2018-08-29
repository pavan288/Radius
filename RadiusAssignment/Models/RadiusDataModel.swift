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
    
    enum CodingKeys: String, CodingKey {
        case object
    }
}

class RadiusObject:  Decodable {
    var facilities: [RadiusFacility]?
    var exclusions: [[RadiusExclusion]]?
    
//    var facilities: String?
//    var exclusions: String?
    
    enum CodingKeys: String, CodingKey {
        case facilities
        case exclusions
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.facilities = try? codingValues.decode([RadiusFacility].self, forKey: .facilities)
        self.exclusions = try? codingValues.decode([[RadiusExclusion]].self, forKey: .exclusions)
    }
}

class RadiusFacility: NSObject, Decodable {
    var facilityId: String?
    var name: String?
    var options: [Option]?
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case name
        case options
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.facilityId = try? codingValues.decode(String.self, forKey: .facilityId)
        self.name = try? codingValues.decode(String.self, forKey: .name)
        self.options = try? codingValues.decode([Option].self, forKey: .options)
    }
}

class Option: NSObject, Codable {
    var name: String?
    var icon: String?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case icon
        case id
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? codingValues.decode(String.self, forKey: .name)
        self.icon = try? codingValues.decode(String.self, forKey: .icon)
        self.id = try? codingValues.decode(String.self, forKey: .id)
        
    }
}

class RadiusExclusions: NSObject, Decodable {
    var exclusion: [RadiusExclusion]?
    
    enum CodingKeys: String, CodingKey {
        case exclusion
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.exclusion = try? codingValues.decode([RadiusExclusion].self, forKey: .exclusion)
    }
}

class RadiusExclusion: NSObject, Decodable {
    var facilityId: String?
    var optionsId: String?
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case optionsId = "options_id"
    }
    
    required init(from decoder: Decoder) throws {
        let codingValues = try decoder.container(keyedBy: CodingKeys.self)
        self.facilityId = try? codingValues.decode(String.self, forKey: .facilityId)
        self.optionsId = try? codingValues.decode(String.self, forKey: .optionsId)
    }
}
