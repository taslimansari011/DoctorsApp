//
//  GlobalEnum.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

enum HTTPMethod: String {
    case get, post
}

enum HTTPError: Error {
    case error(Int?, String)
}
