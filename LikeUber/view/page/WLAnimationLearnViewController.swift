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
import pop

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
    case rotate
    case flipX
    case flipY
    case verticalDelayShow
    case horisonalDelayShow
}

enum AnimationTimeType: String, EnumCollection {
    case easeIn
    case easeOut
    case easeInOut
    case spring
    case linear
}

class WLAnimationLearnViewController: WLBasePageViewController {

    @IBOutlet weak var targetAnimationView: UIButton!

    @IBOutlet weak var usePopFrameworkSwitch: UISwitch!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var forceSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!

    // Option view
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var dampingSlider: UISlider!
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var originXSlider: UISlider!
    @IBOutlet weak var originXLabel: UILabel!
    @IBOutlet weak var originYSlider: UISlider!
    @IBOutlet weak var originYLabel: UILabel!
    @IBOutlet weak var scaleSlider: UISlider!
    @IBOutlet weak var scaleLabel: UILabel!
    private var isOptionViewHide = true

    @IBOutlet weak var animationTypePickView: UIPickerView!
    private var selectedAnimationType: AnimationType = .shake
    private var selectedAnimationTimeType: AnimationTimeType = .easeIn    
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

        // Option View
        dampingSlider.rx.value
            .map { String(format: "Damping: %.1f", $0) }
            .bind(to: dampingLabel.rx.text)
            .disposed(by: baseDisposeBag)
        velocitySlider.rx.value
            .map { String(format: "Velocity: %.1f", $0) }
            .bind(to: velocityLabel.rx.text)
            .disposed(by: baseDisposeBag)
        originXSlider.rx.value
            .map { String(format: "X: %.1f", $0) }
            .bind(to: originXLabel.rx.text)
            .disposed(by: baseDisposeBag)
        originYSlider.rx.value
            .map { String(format: "Y: %.1f", $0) }
            .bind(to: originYLabel.rx.text)
            .disposed(by: baseDisposeBag)
        scaleSlider.rx.value
            .map { String(format: "Scale: %.1f", $0) }
            .bind(to: scaleLabel.rx.text)
            .disposed(by: baseDisposeBag)
    }

    func configurePickerView() {
        animationTypePickView.dataSource = self
        animationTypePickView.delegate = self
    }

    @IBAction func btResetOptionPressed(_ sender: Any) {

    }
    @IBAction func btCodePressed(_ sender: Any) {

    }
    @IBAction func btStartPressed(_ sender: Any) {
        if usePopFrameworkSwitch.isOn {
            applyAnimationWithPop()
        } else {
            applyAnimationWithCA()
        }
    }

    /// 使用原生的Core Animation来实现动画
    func applyAnimationWithCA() {
        // set the animation option
        var animationOption: UIViewAnimationOptions = .curveEaseOut
        switch selectedAnimationTimeType {
        case .easeIn:
            animationOption = .curveEaseIn
        case .easeInOut:
            animationOption = .curveEaseInOut
        case .easeOut:
            animationOption = .curveEaseOut
        case .linear:
            animationOption = .curveLinear
        default:
            break
        }

        // 默认动画动作
        var animation = { [weak self] in
            self?.targetAnimationView.alpha = 1
            self?.targetAnimationView.transform = CGAffineTransform.identity
        }
        let completion: ((Bool) -> Void)? = nil
        // 目前支持的所有动画
        switch selectedAnimationType {
        case .slideDown:
            let offsetY = ScreenHeight
            targetAnimationView.transform = CGAffineTransform(translationX: 0, y: -offsetY) //初始位置屏幕顶部
        case .slideUp:
            let offsetY = ScreenHeight
            targetAnimationView.transform = CGAffineTransform(translationX: 0, y: offsetY) //初始位置屏幕底部
        case .slideLeft:
            let offsetX = ScreenWidth / 2 + targetAnimationView.bounds.width
            targetAnimationView.transform = CGAffineTransform(translationX: offsetX, y: 0)
        case .slideRight:
            let offsetX = -(ScreenWidth / 2 + targetAnimationView.bounds.width)
            targetAnimationView.transform = CGAffineTransform(translationX: offsetX, y: 0)
        case .fall:
            animation = { [weak self] in
                let fallTransform = CGAffineTransform(translationX: 0, y: ScreenHeight)
                let rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 4.0) // 27.5°
                self?.targetAnimationView.transform = rotateTransform.concatenating(fallTransform)
                self?.targetAnimationView.alpha = 0.5
            }
        case .zoomIn:
            targetAnimationView.alpha = 0
            let scale: CGFloat = scaleSlider.value == 1.0 ? 1.5 : CGFloat(scaleSlider.value)
            targetAnimationView.transform = CGAffineTransform(scaleX: scale, y: scale)
        case .zoomOut:
            animation = { [weak self] in
                self?.targetAnimationView.alpha = 0
                self?.targetAnimationView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        case .shake:
            shakeAnimation()
            return
        case .flipX:
            flipXAnimation()
            return
        case .flipY:
            flipYAnimation()
            return
        case .rotate:
            targetAnimationView.transform = CGAffineTransform.identity
            animation = { [weak self] in
                self?.targetAnimationView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 3)
            }
        case .verticalDelayShow, .horisonalDelayShow:
            let vc = UIStoryboard.instantiateViewController(storyboard: .menu,
                                                            viewType: WLAnimationTableViewController.self)
            vc.animationType = selectedAnimationType
            present(vc, animated: true, completion: nil)
            return
        default:
            targetAnimationView.alpha = 0
            targetAnimationView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            break
        }

        let duration = TimeInterval(durationSlider.value)
        let delay = TimeInterval(delaySlider.value)
        let damping = CGFloat(dampingSlider.value)
        let velocity = CGFloat(velocitySlider.value)

        switch selectedAnimationType {
        case .zoomIn, .zoomOut:
            if selectedAnimationTimeType != .spring {
                UIView.animate(withDuration: duration,
                               delay: delay,
                               options: animationOption,
                               animations: animation,
                               completion: completion)
            } else {
                fallthrough
            }
        default:
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: velocity,
                           options: animationOption,
                           animations: animation,
                           completion: completion)
        }
    }

    /// 使用Facebook开源的Pop框架
    func applyAnimationWithPop() {
        switch selectedAnimationType {
        case .pop:
            if let ani = targetAnimationView.pop_animation(forKey: AnimationType.pop.rawValue) as? POPSpringAnimation {
                ani.toValue = 40.0
            } else {
                let scale = POPSpringAnimation()
                scale.toValue = 40.0
                scale.springBounciness = 17.0 // 0~20
                scale.springSpeed = 16.0
                targetAnimationView.pop_add(scale, forKey: AnimationType.pop.rawValue)
            }
        case .slideDown:
            if let ani = targetAnimationView.pop_animation(forKey: AnimationType.slideDown.rawValue) as? POPSpringAnimation {
                ani.toValue = targetAnimationView.frame.y + 100.0
            } else {
                let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                animation?.toValue = targetAnimationView.frame.y + 100.0
                animation?.springBounciness = 17.0 // 0~20
                animation?.springSpeed = 16.0
                targetAnimationView.pop_add(animation, forKey: AnimationType.slideDown.rawValue)
            }
        case .slideUp:
            if let ani = targetAnimationView.pop_animation(forKey: AnimationType.slideUp.rawValue) as? POPSpringAnimation {
                ani.toValue = targetAnimationView.frame.y - 100.0
            } else {
                let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                animation?.toValue = targetAnimationView.frame.y - 100.0
                animation?.springBounciness = 17.0 // 0~20
                animation?.springSpeed = 16.0
                targetAnimationView.pop_add(animation, forKey: AnimationType.slideUp.rawValue)
            }
        case .slideLeft:
            if let ani = targetAnimationView.pop_animation(forKey: AnimationType.slideLeft.rawValue) as? POPSpringAnimation {
                ani.toValue = targetAnimationView.frame.x - 100.0
            } else {
                let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                animation?.toValue = targetAnimationView.frame.x - 100.0
                animation?.springBounciness = 17.0 // 0~20
                animation?.springSpeed = 16.0
                targetAnimationView.pop_add(animation, forKey: AnimationType.slideLeft.rawValue)
            }
        case .slideRight:
            if let ani = targetAnimationView.pop_animation(forKey: AnimationType.slideRight.rawValue) as? POPSpringAnimation {
                ani.toValue = targetAnimationView.frame.x + 100.0
            } else {
                let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                animation?.toValue = targetAnimationView.frame.x + 100.0
                animation?.springBounciness = 17.0 // 0~20
                animation?.springSpeed = 16.0
                targetAnimationView.pop_add(animation, forKey: AnimationType.slideRight.rawValue)
            }
        case .rotate:
            if let ani = targetAnimationView.layer.pop_animation(forKey: AnimationType.rotate.rawValue) as? POPSpringAnimation {
                ani.toValue = Float.pi * 2
            } else {
                let animation = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                animation?.toValue = Float.pi * 2
                animation?.springBounciness = 17.0 // 0~20
                animation?.springSpeed = 16.0
                targetAnimationView.layer.pop_add(animation, forKey: AnimationType.rotate.rawValue)
            }
        case .flipX:
            if let ani = targetAnimationView.layer.pop_animation(forKey: AnimationType.flipX.rawValue) as? POPSpringAnimation {
                ani.toValue = Float.pi
            } else {
                let animation = POPSpringAnimation(propertyNamed: kPOPLayerRotationX)
                animation?.toValue = Float.pi
                animation?.springBounciness = 17.0 // 0~20
                animation?.springSpeed = 16.0
                targetAnimationView.layer.pop_add(animation, forKey: AnimationType.flipX.rawValue)
            }
        case .flipY:
            if let ani = targetAnimationView.layer.pop_animation(forKey: AnimationType.flipY.rawValue) as? POPSpringAnimation {
                ani.toValue = Float.pi
            } else {
                let animation = POPSpringAnimation(propertyNamed: kPOPLayerRotationY)
                animation?.toValue = Float.pi
                animation?.springBounciness = 17.0 // 0~20
                animation?.springSpeed = 16.0
                targetAnimationView.layer.pop_add(animation, forKey: AnimationType.flipY.rawValue)
            }
        default:
            if let ani = targetAnimationView.pop_animation(forKey: "scale") as? POPSpringAnimation {
                if let toValue = ani.toValue as? NSValue,
                    toValue == NSValue(cgPoint: CGPoint(x: 1.3, y: 1.3)) {
                    ani.toValue = NSValue(cgPoint: CGPoint(x: 1.0, y: 1.0))
                } else {
                    ani.toValue = NSValue(cgPoint: CGPoint(x: 1.3, y: 1.3))
                }

            } else {
                let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
                scale?.toValue = NSValue(cgPoint: CGPoint(x: 1.3, y: 1.3))
                scale?.springBounciness = 17.0 // 0~20
                scale?.springSpeed = 16.0
                targetAnimationView.pop_add(scale, forKey: "scale")
            }
        }
    }

    func flipXAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.x")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = TimeInterval(durationSlider.value)
        targetAnimationView.layer.add(animation, forKey: "flipX")
    }

    func flipYAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = TimeInterval(durationSlider.value)

        targetAnimationView.layer.add(animation, forKey: "flipY")
    }

    func shakeAnimation() {
        // 获取到当前的View
        let viewLayer: CALayer = targetAnimationView.layer

        // 获取当前View的位置
        let position = viewLayer.position

        // 移动的两个终点位置
        let rightOffset = CGPoint.init(x: position.x + 20, y: position.y)
        let leftOffset = CGPoint.init(x: position.x - 20, y: position.y)

        // 设置动画
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "position")

        // 设置运动形式
        var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        switch selectedAnimationTimeType {
        case .easeIn:
            timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .easeOut:
            timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .easeInOut:
            timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        case .linear:
            timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        default:
            break;
        }
        animation.timingFunction = timingFunction
        // 设置开始位置
        animation.fromValue = NSValue.init(cgPoint: rightOffset)
        // 设置结束位置
        animation.toValue = NSValue.init(cgPoint: leftOffset)
        // 设置自动反转
        animation.autoreverses = true
        // 设置时间
        animation.duration = TimeInterval(durationSlider.value)
        // 设置次数
        animation.repeatCount = 3
        // 添加上动画
        viewLayer.add(animation, forKey: nil)
    }

    // MARK: option view
    @IBAction func btOptionPressed(_ sender: Any) {
        let optionViewHeight = optionView.bounds.height
        var transition = CGAffineTransform(translationX: 0, y: optionViewHeight)
        var scaleTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        if isOptionViewHide {
            transition = CGAffineTransform(translationX: 0, y: -optionViewHeight)
            let scale = 1.0 - (Const.statusBarHeight * 2 / ScreenHeight)
            scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        }
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8, // 0 ~ 1, 值越大，可弹性越小，但是会有延阻的效果
                       initialSpringVelocity: 0.8, // 0~1 初始力度，值越大，初速度越大
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { [weak self] in
                        self?.optionView.transform = transition
                        self?.rootView.transform = scaleTransform
        }, completion: nil)
        isOptionViewHide = !isOptionViewHide
        setNeedsStatusBarAppearanceUpdate() // update status bar
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isOptionViewHide {
            return .default
        } else {
            return .lightContent
        }
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
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
