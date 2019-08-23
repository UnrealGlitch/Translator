//
//  HistoryViewControllerModel.swift
//  Translator
//
//  Created by MadBrain on 21/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import RxSwift
import RxCocoa

protocol HistoryViewControllerModelOutput: class {
    
    func onCellSelection(with data: HistoryTranslation)
    
}

final class HistoryViewControllerModel: BaseViewModel {
    
    // MARK: Variables
    
    weak var output: HistoryViewControllerModelOutput?
    
    var historyCellsCount: Int {
        return UserDefaultsService.instance.history.count
    }
    
    // MARK: Life cycle
    
    init(output: HistoryViewControllerModelOutput) {
        self.output = output
    }
    
    // MARK: Public
    
    func getHistoryItem(at index: Int) -> HistoryTranslation {
        return UserDefaultsService.instance.history[index]
    }
    
    func onCellSelection(at index: Int) {
        output?.onCellSelection(with: UserDefaultsService.instance.history[index])
    }
    
    func remove(at index: Int) {
        UserDefaultsService.instance.remove(at: index)
    }
    
}
