//
//  BaseViewController.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import RxSwift

protocol MvvmConforming: class {
    
    associatedtype ViewModelType: BaseViewModel
    var viewModel: ViewModelType! { get set }
    init(viewModel: ViewModelType)
    
}

class BaseViewController<T: BaseViewModel>: UIViewController, MvvmConforming {
    
    // MARK: Variables
    
    var viewModel: T!
    var shouldHideNavigationBar = false
    
    // MARK: Life cycle
    
    required init(viewModel: T) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(shouldHideNavigationBar, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.first !== self
    }
    
}
