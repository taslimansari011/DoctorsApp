//
//  CoreDataRepository.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

protocol CoreDataRepository {
    
    associatedtype T
    
    func create(model: T)
    func get(by id: Int) -> T?
    func getAll() -> [T]?
    func update(model: T) -> Bool
    func delete(model: T) -> Bool
}
