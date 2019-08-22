//
//  HistoryViewController.swift
//  Translator
//
//  Created by MadBrain on 21/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit
import RxSwift

final class HistoryViewController: BaseViewController<HistoryViewControllerModel> {
    
    // MARK: Variables
    
    @IBOutlet private weak var tableView: UITableView!
    
    final let disposeBag = DisposeBag()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    // MARK: Private
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(forClass: HistoryViewCell.self)
    }
    
}

// MARK: UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.historyCellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HistoryViewCell.self, for: indexPath)
        
        let historyItem = viewModel.getHistoryItem(at: indexPath.row)
        cell.viewModel = HistoryViewCellModel(text: historyItem.text,
                                              translatedText: historyItem.translatedText,
                                              time: historyItem.time)
        return cell
    }
    
}
