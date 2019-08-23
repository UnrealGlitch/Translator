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
    
    private var loadingLabel: UILabel?
    private var speakerImageView: UIImageView?
    private var buttonsContainer: UIView?
    private var startButton: TUIButton?
    private var historyButton: TUIButton?
    
    private let labelConstraintGroup = ConstraintGroup()
    private let buttonsConstraintGroup = ConstraintGroup()
    private let imageViewConstraintGroup = ConstraintGroup()
    
    private let buttonsContainerSize = CGSize(width: 200, height: 100)
    private let speakerImageViewSize = CGSize(width: 250, height: 250)
    private let margin: CGFloat = 10
    
    private var loadingLabelWidth: CGFloat {
        return loadingLabel?.intrinsicContentSize.width ?? 0
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
            animateConstraints()
            viewModel.isFirstAppearance.toggle()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewModel.isFirstAppearance {
            guard let buttonsContainer = buttonsContainer,
                  let startButton = startButton,
                  let historyButton = historyButton,
                  let loadingLabel = loadingLabel,
                  let speakerImageView = speakerImageView
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
                container.width == self.buttonsContainerSize.width
                container.height == self.buttonsContainerSize.height
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
        }
    }
    
    // MARK: Private
    
    private func configureView() {
        shouldHideNavigationBar = true
        
        let loadingLabel = UILabel(text: "Loading")
        let speakerImageView = UIImageView(image: UIImage(named: "mainScreenLogo"))
        speakerImageView.contentMode = .scaleAspectFit
        speakerImageView.clipsToBounds = true
        
        view.addSubview(loadingLabel)
        view.addSubview(speakerImageView)
        
        self.loadingLabel = loadingLabel
        self.speakerImageView = speakerImageView
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
    
    private func animateConstraints() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.backgroundColor = UIColor.applicationGray.withAlphaComponent(0.3)
        }) { [weak self] _ in
            self?.setNewConstraints()

            UIView.animate(withDuration: 1.5, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    private func setNewConstraints() {
        guard let buttonsContainer = buttonsContainer, let loadingLabel = loadingLabel else {
            return
        }
        
        constrain(loadingLabel, view, replace: labelConstraintGroup) { (label, view) in
            label.right == view.left
        }
        
        constrain(buttonsContainer, view, replace: buttonsConstraintGroup) { [weak self] (container, view) in
            guard let self = self else {
                return
            }
            
            container.bottom == view.bottom - self.margin
            container.centerX == view.centerX
            container.width == self.buttonsContainerSize.width
            container.height == self.buttonsContainerSize.height
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
