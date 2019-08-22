//
//  UIViewExtensions.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

fileprivate class GestureRecognizerTapHandler: UITapGestureRecognizer {
    
    private var tapAction: ((UITapGestureRecognizer) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public init(tapCount: Int = 1, fingerCount: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        self.init()
        
        self.numberOfTapsRequired = tapCount
        self.numberOfTouchesRequired = fingerCount
        self.tapAction = action
        self.addTarget(self, action: #selector(GestureRecognizerTapHandler.didTap(_:)))
    }
    
    @objc open func didTap(_ tap: UITapGestureRecognizer) {
        tapAction?(tap)
    }
    
}

extension UIView {
    
    public class func viewFromNib(nibName: String? = nil) -> Self {
        func fromNibHelper<T>(nibName: String?) -> T where T : UIView {
            let bundle = Bundle(for: T.self)
            let name = nibName ?? String(describing: T.self)
            return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
        }
        return fromNibHelper(nibName: nibName)
    }
    
    public func whenTapped(tapCount: Int = 1, fingerCount: Int = 1, _ action: @escaping ((UITapGestureRecognizer) -> Void)){
        let tap = GestureRecognizerTapHandler(tapCount: tapCount, fingerCount: fingerCount, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
}
