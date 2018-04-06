//
//  UIViewController+Additions.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 3/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//


import UIKit

extension UIViewController {
    
    func wrappedInNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
