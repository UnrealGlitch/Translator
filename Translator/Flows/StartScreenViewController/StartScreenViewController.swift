//
//  StartScreenViewController.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit
import Cartography

final class StartScreenViewController: BaseViewController<StartScreenViewControllerModel> {
    
    // MARK: Variables
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var speakerImageView: UIImageView!

    private var buttonsContainer: UIView?
    private var backgroundImageView: UIImageView?
    private var startButton: TUIButton?
    private var historyButton: TUIButton?
    
    private let labelConstraintGroup = ConstraintGroup()
    private let buttonsConstraintGroup = ConstraintGroup()
    private let imageViewConstraintGroup = ConstraintGroup()
    
    private let buttonsContainerHeight: CGFloat = 200
    private let buttonsContainerWidth: CGFloat = 400
    private let speakerImageViewSize = CGSize(width: 250, height: 250)
    private let margin: CGFloat = 10
    
    private var loadingLabelWidth: CGFloat {
        return loadingLabel.intrinsicContentSize.width
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.isFirstAppearance {
            animateConstrains()
            viewModel.isFirstAppearance = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewModel.isFirstAppearance {
            guard let buttonsContainer = buttonsContainer,
                  let backgroundImageView = backgroundImageView,
                  let startButton = startButton,
                  let historyButton = historyButton
            else {
                return
            }
            
            constrain(speakerImageView, view) { [weak self] (view, superView) in
                guard let self = self else {
                    return
                }
                view.height == self.speakerImageViewSize.height
                view.width == self.speakerImageViewSize.width
                view.center == superView.center
            }
            
            constrain(loadingLabel, speakerImageView) { [weak self] (label, imageView) in
                guard let self = self else {
                    return
                }
                label.top == imageView.bottom + self.margin
            }
            
            constrain(loadingLabel, view, replace: labelConstraintGroup) { (label, view) in
                label.centerX == view.centerX
            }
            
            constrain(buttonsContainer, view, replace: buttonsConstraintGroup) { [weak self] (container, view) in
                guard let self = self else {
                    return
                }
                container.centerX == view.centerX
                container.width == self.buttonsContainerWidth
                container.height == self.buttonsContainerHeight
                container.top == view.bottom
            }
            
            constrain(buttonsContainer, startButton) { (container, startButton) in
                startButton.left == container.left
                startButton.right == container.right
                startButton.top == container.top
                startButton.height == container.height / 2 - margin / 2
            }

            constrain(buttonsContainer, historyButton) { (container, historyButton) in
                historyButton.left == container.left
                historyButton.right == container.right
                historyButton.bottom == container.bottom
                historyButton.height == container.height / 2 - margin / 2
            }
            
            constrain(backgroundImageView, view) { (imageView, view) in
                imageView.edges == view.edges
            }
        }
    }
    
    // MARK: Private
    
    private func configureView() {
        shouldHideNavigationBar = true
        let backgroundImageView = UIImageView(image: UIImage(named: "mainScreenBackground"))
        backgroundImageView.alpha = 0
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        self.backgroundImageView = backgroundImageView
    }
    
    private func configureButtons() {
        let startButton = TUIButton()
        let historyButton = TUIButton()
        
        startButton.addTarget(self, action: #selector(onStartButtonTapped), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(onHistoryButtonTapped), for: .touchUpInside)
        startButton.setTitle("Translate", for: .normal)
        historyButton.setTitle("History", for: .normal)
        
        self.startButton = startButton
        self.historyButton = historyButton
        
        let buttonsContainer = UIView()
        buttonsContainer.addSubview(startButton)
        buttonsContainer.addSubview(historyButton)
        view.addSubview(buttonsContainer)
        
        self.buttonsContainer = buttonsContainer
    }
    
    private func animateConstrains() {
        constrain(loadingLabel, view, replace: labelConstraintGroup) { [weak self] (label, view) in
            guard let self = self else {
                return
            }
            label.centerX == view.centerX + self.margin
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.backgroundImageView?.alpha = 1
            self.view.layoutIfNeeded()
        }) { [weak self] _ in
            guard let self = self, let buttonsContainer = self.buttonsContainer else {
                return
            }
            
            constrain(self.loadingLabel, self.view, replace: self.labelConstraintGroup) { (label, view) in
                label.right == view.left
            }
            
            constrain(buttonsContainer, self.view, replace: self.buttonsConstraintGroup) { [weak self] (container, view) in
                guard let self = self else {
                    return
                }
                
                container.bottom == view.bottom - self.margin
                container.centerX == view.centerX
                container.width == self.buttonsContainerWidth
                container.height == self.buttonsContainerHeight
            }
            
            UIView.animate(withDuration: 1.5, animations: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: Actions
    
    @objc func onStartButtonTapped() {
        viewModel.onStartButtonTapped()
    }
    
    @objc func onHistoryButtonTapped() {
        viewModel.onHistoryButtonTapped()
    }
    
}
