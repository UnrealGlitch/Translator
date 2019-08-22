//
//  TranslateViewController.swift
//  Translator
//
//  Created by MadBrain on 20/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit
import RxSwift
import SwifterSwift
import PinLayout

class TranslateViewController: BaseViewController<TranslateViewControllerModel> {
    
    // MARK: Variables
    
    private enum PickerTypes: Int {
        
        case originalPicker
        case targetPicker
        
    }
    
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var translatedTextView: UITextView!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var responseLanguageSwitch: UISwitch!
    @IBOutlet private weak var responseLanguageLabel: UILabel!
    @IBOutlet private weak var fromLabel: UILabel!
    @IBOutlet private weak var toLabel: UILabel!
    @IBOutlet private weak var originalLanguageTextField: UITextField!
    @IBOutlet private weak var targetLanguageTextField: UITextField!
    
    private var textViews: UIView?
    
    private var originalPickerView: UIPickerView?
    private var targetPickerView: UIPickerView?
    
    private var originalPickerViewValue: String?
    private var targetPickerViewValue: String?
    
    private let pickerTextFieldWidth: CGFloat = 50
    private let margin: CGFloat = 10
    private let extendedMargin: CGFloat = 20
    
    final let disposeBag = DisposeBag()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTextViews()
        configurePickers()
        configureClearButton()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let textViews = textViews else {
            return
        }
        
        clearButton.pin
            .left()
            .right()
            .bottom(view.pin.safeArea)
            .marginBottom(extendedMargin)
            .height(clearButton.intrinsicContentSize.height)
        
        fromLabel.pin.above(of: clearButton).left(margin).marginBottom(extendedMargin)
        
        originalLanguageTextField.pin
            .after(of: fromLabel)
            .above(of: clearButton)
            .marginLeft(margin)
            .height(originalLanguageTextField.intrinsicContentSize.height)
            .width(pickerTextFieldWidth)
            .marginBottom(extendedMargin)
        
        toLabel.pin
            .after(of: originalLanguageTextField)
            .above(of: clearButton)
            .marginLeft(margin)
            .marginBottom(extendedMargin)
        
        targetLanguageTextField.pin
            .after(of: toLabel)
            .above(of: clearButton)
            .marginLeft(margin)
            .height(targetLanguageTextField.intrinsicContentSize.height)
            .width(pickerTextFieldWidth)
            .marginBottom(extendedMargin)
        
        textViews.pin
            .top(view.pin.safeArea)
            .above(of: fromLabel)
            .left(margin)
            .right(margin)
            .marginBottom(extendedMargin)
            .marginTop(margin)
        
        inputTextView.pin.top().left().right().height(textViews.bounds.height / 2 - margin)
        translatedTextView.pin.below(of: inputTextView).marginTop(margin).left().right().bottom()
    }
    
    // MARK: Private
    
    private func configureView() {
        view.whenTapped { [weak self] _ in
            self?.view.endEditing(true)
        }
    }
    
    private func configureTextViews() {
        inputTextView.text = nil
        inputTextView.backgroundColor = .textViewBackground
        inputTextView.delegate = self
        inputTextView.borderColor = .gray
        inputTextView.borderWidth = 1.0
        
        translatedTextView.text = nil
        translatedTextView.backgroundColor = .textViewBackground
        translatedTextView.borderColor = .blue
        translatedTextView.borderWidth = 1.0
        translatedTextView.isUserInteractionEnabled = false
        
        let textViews = UIView()
        textViews.addSubview(inputTextView)
        textViews.addSubview(translatedTextView)
        view.addSubview(textViews)
        
        self.textViews = textViews
    }
    
    private func configurePickers() {
        let originalPickerView = UIPickerView()
        let targetPickerView = UIPickerView()
        configureLanguagePicker(originalPickerView, for: originalLanguageTextField, pickerType: .originalPicker)
        configureLanguagePicker(targetPickerView, for: targetLanguageTextField, pickerType: .targetPicker)
        
        self.originalPickerView = originalPickerView
        self.targetPickerView = targetPickerView
    }
    
    private func configureLanguagePicker(_ pickerView: UIPickerView, for textField: UITextField, pickerType: PickerTypes) {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.tag = pickerType.rawValue
        
        textField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(onSelectPickerView(_ :)))
        doneButton.tag = pickerType.rawValue
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: textField,
                                           action: #selector(UITextField.resignFirstResponder))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    private func configureClearButton() {
        clearButton.addTarget(self, action: #selector(onClearButtonTapped), for: .touchUpInside)
    }
    
    private func bind() {
        viewModel.languages.asObservable().observeOn(MainScheduler.asyncInstance).subscribe { [weak self] _ in
            self?.originalPickerView?.reloadAllComponents()
            self?.targetPickerView?.reloadAllComponents()
        }.disposed(by: disposeBag)
        
        viewModel.translatedText.asObservable().observeOn(MainScheduler.asyncInstance).subscribe { [weak self] (translatedText) in
            guard let translatedText = translatedText.element else {
                return
            }
            
            self?.translatedTextView.clear()
            translatedText.forEach() { [weak self] in
                self?.translatedTextView.text += $0
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK: Actions
    
    @objc func onSelectPickerView(_ sender: UIButton) {
        switch sender.tag {
            
        case PickerTypes.originalPicker.rawValue:
            if let originalPickerView = originalPickerView {
                let selectedRow = originalPickerView.selectedRow(inComponent: 0)
                self.pickerView(originalPickerView, didSelectRow: selectedRow, inComponent: 0)
                originalLanguageTextField.text = originalPickerViewValue
                originalLanguageTextField.resignFirstResponder()
            }
            
        case PickerTypes.targetPicker.rawValue:
            if let targetPickerView = targetPickerView {
                let selectedRow = targetPickerView.selectedRow(inComponent: 0)
                self.pickerView(targetPickerView, didSelectRow: selectedRow, inComponent: 0)
                targetLanguageTextField.text = targetPickerViewValue
                targetLanguageTextField.resignFirstResponder()
            }
            
        default:
            break
            
        }
    }
    
    @objc func onClearButtonTapped() {
        inputTextView.clear()
        translatedTextView.clear()
    }
    
}

// MARK: UITextViewDelegate

extension TranslateViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.textViewDidChange(textView.text)
    }
    
}

// MARK: UIPickerViewDelegate

extension TranslateViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.languages.value[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
            
        case originalPickerView:
            originalPickerViewValue = viewModel.languages.value[row]
            
        case targetPickerView:
            targetPickerViewValue = viewModel.languages.value[row]
            
        default:
            break
            
        }
    }
    
}

// MARK: UIPickerViewDataSource

extension TranslateViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.languages.value.count
    }
    
}
