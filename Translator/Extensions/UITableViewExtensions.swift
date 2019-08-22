//
//  UITableViewExtensions.swift
//  Translator
//
//  Created by MadBrain on 21/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerNib(forClass neededClass: AnyClass) {
        register(UINib(nibName: String(describing: neededClass),
                       bundle: Bundle.main),
                 forCellReuseIdentifier: String(describing: neededClass))
    }
    
}
