//
//  CDMedicine+CoreDataProperties.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//
//

import Foundation
import CoreData


extension CDMedicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMedicine> {
        return NSFetchRequest<CDMedicine>(entityName: "CDMedicine")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var packform: String?
    @NSManaged public var company: String?
    @NSManaged public var strength: String?
    @NSManaged public var strengthtype: String?

}

extension CDMedicine : Identifiable {
    
    func convertToMedicine() -> Medicine {
        return Medicine(id: Int(id), name: name, type: type, company: company, strength: strength, strengthtype: strengthtype)
    }
}
