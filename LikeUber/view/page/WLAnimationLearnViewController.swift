//
//  WLAnimationLearnViewController.swift
//  LikeUber
//
//  Created by wanglei on 2018/9/4.
//  Copyright © 2018 lei wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum AnimationType: String, EnumCollection {
    case shake
    case pop
    case zoomIn
    case zoomOut
    case slideDown
    case slideUp
    case slideLeft
    case slideRight
    case fall
}

enum AnimationTimeType: String, EnumCollection {
    case caseIn
    case caseOut
    case caseInOut
    case spring
    case linear
}

class WLAnimationLearnViewController: WLBasePageViewController {

    @IBOutlet weak var targetAnimationView: UIButton!
    @IBOutlet weak var forceSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var animationTypePickView: UIPickerView!
    private var selectedAnimationType: AnimationType = .shake
    private var selectedAnimationTimeType: AnimationTimeType = .caseIn    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    func setupView() {
        configureSliderView()
        configurePickerView()
    }

    func configureSliderView() {
        durationSlider.rx.value
            .map { value -> String in
                return String(format: "Duration: %.1f", value)
            }.bind(to: durationLabel.rx.text)
            .disposed(by: baseDisposeBag)

        forceSlider.rx.value
            .map { String(format: "Force: %.1f", $0) }
            .bind(to: forceLabel.rx.text)
            .disposed(by: baseDisposeBag)

        delaySlider.rx.value
            .map { String(format: "Delay: %.1f", $0) }
            .bind(to: delayLabel.rx.text)
            .disposed(by: baseDisposeBag)
    }

    func configurePickerView() {
        animationTypePickView.dataSource = self
        animationTypePickView.delegate = self
    }

    @IBAction func btCodePressed(_ sender: Any) {

    }
    @IBAction func btStartPressed(_ sender: Any) {
        targetAnimationView.alpha = 0
        targetAnimationView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        UIView.animate(withDuration: TimeInterval(durationSlider.value),
                       animations: { [weak self] in
                        self?.targetAnimationView.alpha = 1
                        self?.targetAnimationView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { [weak self] _ in
            UIView.animate(withDuration: TimeInterval(self?.durationSlider.value ?? 0.3),
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: { [weak self] in
                            self?.targetAnimationView.transform = CGAffineTransform.identity
                }, completion: nil)
        }
    }
    @IBAction func btOptionPressed(_ sender: Any) {
    }
}

extension WLAnimationLearnViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return AnimationType.allValues.count
        case 1:
            return AnimationTimeType.allValues.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return AnimationType.allValues[row].rawValue
        case 1:
            return AnimationTimeType.allValues[row].rawValue
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedAnimationType = AnimationType.allValues[row]
        case 1:
            selectedAnimationTimeType = AnimationTimeType.allValues[row]
        default:
            break
        }
    }
}
