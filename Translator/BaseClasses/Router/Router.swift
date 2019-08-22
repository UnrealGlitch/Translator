//
//  Router.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

protocol Presentable {
    
    func toPresent() -> UIViewController?
    
}

protocol Router: Presentable {
    
    var rootController: UINavigationController { get }
    
    func push(_ module: Presentable?)
    func popModule()
    func dismissModule()
    func installRootModule(_ module: Presentable?)
    
}
