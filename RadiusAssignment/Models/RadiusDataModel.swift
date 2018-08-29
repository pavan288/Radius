//
//  RadiusDataModel.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 29/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import Foundation

class RadiusDataModel: NSObject, Codable {
    var object: RadiusObject?
    
    enum CodingKeys: String, CodingKey {
        case object
    }
    
    required init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }
}

class RadiusObject: NSObject, Codable {
    var facilities: [RadiusFacility]?
    var exclusions: [[RadiusExclusion]]?
    
    enum CodingKeys: String, CodingKey {
        case facilities
        case exclusions
    }
    
    required init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }
}

class RadiusFacility: NSObject, Codable {
    var facilityId: Int?
    var name: String?
    var options: [Option]?
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case name
        case options
    }
    
    required init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }
}

class Option: NSObject, Codable {
    var name: String?
    var icon: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case icon
        case id
    }
    
    required init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }
}

class RadiusExclusion: NSObject, Codable {
    var facilityId: Int?
    var optionsId: Int?
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case optionsId = "options_id"
    }
    
    required init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }
}
