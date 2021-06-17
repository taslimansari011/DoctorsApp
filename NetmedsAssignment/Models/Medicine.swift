//
//  Medicine.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

struct Medicine: Codable {

    var id: Int?
    var name: String?
    var type: String?
    var company: String?
    var packform: String?
    var strength: String?
    var strengthtype: String?
    var isSelected: Bool = false
    var dosage: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case company = "company"
        case packform = "packform"
        case strength = "strength"
        case strengthtype = "strengthtype"
    }
}
