//
//  ViewController.swift
//  Demo
//
//  Created by Suguru Kishimoto on 11/15/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import UIKit
import PullToDismiss

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var demoButton1: UIButton!
    @IBOutlet private weak var demoButton2: UIButton!
    @IBOutlet private weak var demoButton3: UIButton!
    @IBOutlet private weak var backgroundSwitch: UISegmentedControl!
    @IBOutlet private weak var colorTextField: UITextField!
    @IBOutlet private weak var currentColorView: UIView!
    @IBOutlet private weak var alphaSlider: UISlider!
    @IBOutlet private weak var alphaLabel: UILabel!
    @IBOutlet private weak var dismissableHeightPercentageSlider: UISlider!
    @IBOutlet private weak var dismissableHeightPercentageLabel: UILabel!
    @IBOutlet private weak var disableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons: [UIButton] = [demoButton1, demoButton2, demoButton3]
        buttons.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(demoButtonDidTap(_:)), for: .touchUpInside)
        }
        
        update()
        backgroundSwitch.addTarget(self, action: #selector(switchDidChange(segmentedControl:)), for: .valueChanged)
        alphaSlider.addTarget(self, action: #selector(alphaDidChange(_:)), for: .valueChanged)
        dismissableHeightPercentageSlider.addTarget(self, action: #selector(dismissableHeightDidChange(_:)), for: .valueChanged)
        colorTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: .UITextFieldTextDidChange, object: nil)        
    }
    
    private func update(animated: Bool = false) {
        let animations: () -> Void = { [weak self] in
            self?.backgroundSwitch.selectedSegmentIndex = self?.selectedSegmentIndex(from: Config.shared.background) ?? 0
            self?.currentColorView.backgroundColor = Config.shared.background.color
            self?.alphaSlider.setValue(Float(Config.shared.background.alpha), animated: animated)
            self?.dismissableHeightPercentageSlider.setValue(Float(Config.shared.dismissableHeightPercentage), animated: animated)
            self?.disableView.alpha = self?.backgroundSwitch.selectedSegmentIndex == 0 ? 1.0 : 0.0
            self?.colorTextField.text = Config.shared.background.color?.hexString.map { "#\($0)" }
            self?.alphaLabel.text = String(format: "%.2f", Config.shared.background.alpha)
            self?.dismissableHeightPercentageLabel.text = String(format: "%.2f", Config.shared.dismissableHeightPercentage)
        }
        if !animated {
            animations()
        } else {
            UIView.animate(withDuration: 0.2, animations: animations)
        }
    }
    
    private func selectedSegmentIndex(from background: PullToDismiss.Background) -> Int {
        if case .none = Config.shared.background {
            return 0
        } else {
            return 1
        }
    }
    
    @objc private func switchDidChange(segmentedControl: UISegmentedControl) {
        Config.shared.background = (segmentedControl.selectedSegmentIndex == 0) ? .none : .defaultShadow
        view.endEditing(true)
        update(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @objc private func textDidChange(_: Notification) {
        if colorTextField.isFirstResponder {
            let text = (colorTextField.text ?? "").replacingOccurrences(of: "#", with: "")
            if text.characters.count == 6 {
                Config.shared.background = Config.shared.background.change(color: UIColor(hexString: text, alpha: 1.0))
                currentColorView.backgroundColor = Config.shared.background.color
            } else {
                Config.shared.background = Config.shared.background.change(color: .clear)
                currentColorView.backgroundColor = Config.shared.background.color
            }
        }
    }
    
    @objc private func alphaDidChange(_ slider: UISlider) {
        Config.shared.background = Config.shared.background.change(alpha: CGFloat(slider.value))
        update()
    }

    @objc private func dismissableHeightDidChange(_ slider: UISlider) {
        Config.shared.dismissableHeightPercentage = CGFloat(slider.value)
        update()
    }
    
    @objc private func demoButtonDidTap(_ button: UIButton) {
        view.endEditing(true)
        
        let vc: UIViewController = { () -> UIViewController in
            switch button {
            case demoButton1:
                let vc = SampleTableViewController()
                let nav = UINavigationController(rootViewController: vc)
                return nav
            case demoButton2:
                return SampleCollectionViewController(collectionViewLayout: SampleCollectionLayout())
            case demoButton3:
                let storyboard = UIStoryboard(name: "SampleCustomViewController", bundle: nil)
                return storyboard.instantiateInitialViewController()!
            default:
                fatalError()
            }
        }()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

