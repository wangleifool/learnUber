//
//  UIView+Reactive.swift
//  LikeUber
//
//  Created by wanglei on 2018/12/27.
//  Copyright © 2018 lei wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//extension Reactive where Base: UIView {
//    func rotateEndless(duration: TimeInterval) -> Observable<Void> {
//        var isDisposed = false
//        return Observable<Void>.create { (observer) -> Disposable in
//            func rotate() {
//                UIView.animate(withDuration: duration, animations: {
//                    self.base.transform = self.base.transform.rotated(by: .pi / 2)
//                }, completion: { (_) in
//                    observer.onNext(())
//                    if !isDisposed {
//                        rotate()
//                    }
//                })
//            }
//
//            rotate()
//
//            return Disposables.create {
//                isDisposed = true
//            }
//        }
//    }
//
//    func shift(offset: CGPoint, duration: TimeInterval) -> Observable<Void> {
//        return Observable<Void>.create({ (observer) -> Disposable in
//            UIView.animate(withDuration: duration, animations: {
//                var frame = self.base.frame
//                frame.origin.x += offset.x
//                frame.origin.y += offset.y
//                self.base.frame = frame
//            }, completion: { (_) in
//                observer.onNext(())
//                observer.onCompleted()
//            })
//            return Disposables.create()
//        })
//    }
//
//    func fade(duration: TimeInterval) -> Observable<Void> {
//        return Observable<Void>.create({ (observer) -> Disposable in
//            UIView.animate(withDuration: duration, animations: {
//                self.base.alpha = 0
//            }, completion: { (_) in
//                observer.onNext(())
//                observer.onCompleted()
//            })
//            return Disposables.create()
//        })
//    }
//
//    func appear(duration: TimeInterval) -> Observable<Void> {
//        return Observable<Void>.create({ (observer) -> Disposable in
//            UIView.animate(withDuration: duration, animations: {
//                self.base.alpha = 1
//            }, completion: { (_) in
//                observer.onNext(())
//                observer.onCompleted()
//            })
//            return Disposables.create()
//        })
//    }
//}

extension Reactive where Base: UIView {
    func rotateEndless(duration: TimeInterval) -> Observable<Void> {
        var isDisposed = false
        return Observable<Void>.create { (observer) -> Disposable in
            func rotate() {
                UIView.animate(withDuration: duration, animations: {
                    self.base.transform = self.base.transform.rotated(by: .pi / 2)
                }, completion: { (_) in
                    observer.onNext(())
                    if !isDisposed {
                        rotate()
                    }
                })
            }

            rotate()

            return Disposables.create {
                isDisposed = true
            }
        }
    }

    func rotate(angle: CGFloat = .pi / 2, times: Int, durationPerTimes: TimeInterval) -> Completable {
        return Completable.create { (completable) -> Disposable in
            var times = times
            func rotate() {
                UIView.animate(withDuration: durationPerTimes, animations: {
                    self.base.transform = self.base.transform.rotated(by: angle)
                }, completion: { (_) in
                    if times != 0 {
                        times -= 1
                        rotate()
                    } else {
                        completable(.completed)
                    }
                })
            }
            rotate()
            return Disposables.create()
        }
    }

    func shift(offset: CGPoint, duration: TimeInterval) -> Completable {
        return Completable.create(subscribe: { (completable) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                var frame = self.base.frame
                frame.origin.x += offset.x
                frame.origin.y += offset.y
                self.base.frame = frame
            }, completion: { (_) in
                completable(.completed)
            })
            return Disposables.create()
        })
    }

    func fade(duration: TimeInterval) -> Completable {
        return Completable.create { (completable) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.alpha = 0
            }, completion: { (_) in
                completable(.completed)
            })
            return Disposables.create()
        }
    }

    func appear(duration: TimeInterval) -> Completable {
        return Completable.create(subscribe: { (completable) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.alpha = 1
            }, completion: { (_) in
                completable(.completed)
            })
            return Disposables.create()
        })
    }
}
