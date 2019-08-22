//
//  MainFlowCoordinator.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

final class MainFlowCoordinator: BaseCoordinator {
    
    private let router: Router?
    
    init(router: Router) {
        self.router = router
        
        super.init()
    }
    
    override func start() {
        super.start()
        
        showMainScreen()
    }
    
    func showMainScreen() {
        let vm = StartScreenViewControllerModel(output: self)
        let vc = StartScreenViewController(viewModel: vm)
        router?.installRootModule(vc)
    }
    
}

// MARK: StartScreenViewControllerModelOutput

extension MainFlowCoordinator: StartScreenViewControllerModelOutput {
    
    func onStartButtonTapped() {
        let vm = TranslateViewControllerModel(output: self)
        let vc = TranslateViewController(viewModel: vm)
        router?.push(vc)
    }
    
    func onHistoryButtonTapped() {
        let vm = HistoryViewControllerModel(output: self)
        let vc = HistoryViewController(viewModel: vm)
        router?.push(vc)
    }
    
}

// MARK: TranslateViewControllerModelOutput

extension MainFlowCoordinator: TranslateViewControllerModelOutput {
    
}

// MARK: HistoryViewControllerModelOutput

extension MainFlowCoordinator: HistoryViewControllerModelOutput {
    
}
