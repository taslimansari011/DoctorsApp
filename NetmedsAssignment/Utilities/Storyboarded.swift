//
//  Storyboarded.swift
//  NetmedsAssignment
//
//  Created by macadmin on 16/06/21.
//

import Foundation
import UIKit

enum StoryBoardName: String {
    case main = "Main"
}

protocol StoryBoarded {
    static func instantiaite(storyboard: StoryBoardName) -> Self
}

extension StoryBoarded where Self: UIViewController {
    
    static func instantiaite(storyboard: StoryBoardName) -> Self {
        let id = String(describing: self)
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(identifier: id) as! Self
    }
}
