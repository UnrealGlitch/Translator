//
//  DefaultRouter.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

final class DefaultRouter: NSObject, Router {
    
    // MARK: Variables
    
    let rootController: UINavigationController
    
    // MARK: Life cycle
    
    init(rootController: UINavigationController) {
        rootController.navigationBar.isHidden = false
        self.rootController = rootController    }
    
    // MARK: Public
    
    public func toPresent() -> UIViewController? {
        return rootController
    }

    public func dismissModule() {
        rootController.dismiss(animated: true, completion: nil)
    }

    public func push(_ module: Presentable?) {
        guard let controller = module?.toPresent() else {
            return
        }
        
        rootController.pushViewController(controller, animated: true)
    }
 
    public func popModule() {
        rootController.popViewController(animated: true)
    }
    
    public func installRootModule(_ module: Presentable?) {
        guard let controller = module?.toPresent() else {
            return
        }
        rootController.setViewControllers([controller], animated: false)
    }
    
}
