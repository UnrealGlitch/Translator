//
//  AppCoordinator.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    // MARK: Global variables
    
    private weak var window: UIWindow?
    private let router: Router
    
    // MARK: Lifecycle
    
    init(window: UIWindow) {
        self.window = window
        let nvc = UINavigationController()
        nvc.isNavigationBarHidden = false
        
        window.rootViewController = nvc
        window.rootViewController?.navigationController?.setNavigationBarHidden(false, animated: false)
        
        router = DefaultRouter(rootController: nvc)
        
        super.init()
    }
    
    // MARK: Private
    
    private func startMainFlowCoordinator() {
        let coordinator = MainFlowCoordinator(router: router)
        addDependency(coordinator)
        
        coordinator.start()
    }
    
    // MARK: Public
    
    override func start() {
        startMainFlowCoordinator()
    }
    
}
