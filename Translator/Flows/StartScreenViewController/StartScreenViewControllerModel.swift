//
//  StartScreenViewControllerModel.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

protocol StartScreenViewControllerModelOutput: class {
    
    func onStartButtonTapped()
    func onHistoryButtonTapped()
    
}

final class StartScreenViewControllerModel: BaseViewModel {
    
    // MARK: Variables
    
    private weak var output: StartScreenViewControllerModelOutput?
    
    var isFirstAppearance = true
    
    // MARK: Life cycle
    
    init(output: StartScreenViewControllerModelOutput) {
        self.output = output
    }
    
    // MARK: Public
    
    public func onStartButtonTapped() {
        output?.onStartButtonTapped()
    }
    
    public func onHistoryButtonTapped() {
        output?.onHistoryButtonTapped()
    }
    
}
