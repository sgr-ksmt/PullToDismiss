//
//  PullToDismiss.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 11/13/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

open class PullToDismiss: NSObject {
    
    public struct Defaults {
        private init() {}
        public static let dismissableHeightPercentage: CGFloat = 0.33
    }
    
    open var backgroundEffect: BackgroundEffect? = ShadowEffect.default
    open var edgeShadow: EdgeShadow? = EdgeShadow.default
    
    public var dismissAction: (() -> Void)?
    public weak var delegateProxy: AnyObject?
    public var dismissableHeightPercentage: CGFloat = Defaults.dismissableHeightPercentage {
        didSet {
            dismissableHeightPercentage = min(max(0.0, dismissableHeightPercentage), 1.0)
        }
    }

    fileprivate var viewPositionY: CGFloat = 0.0
    fileprivate var dragging: Bool = false
    fileprivate var previousContentOffsetY: CGFloat = 0.0
    fileprivate weak var viewController: UIViewController?
    
    private var __scrollView: UIScrollView?
    private var panGesture: UIPanGestureRecognizer?
    private var backgroundView: UIView?
    private var navigationBarHeight: CGFloat = 0.0
    private var blurSaturationDeltaFactor: CGFloat = 1.8
    convenience public init?(scrollView: UIScrollView) {
        guard let viewController = type(of: self).viewControllerFromScrollView(scrollView) else {
            print("a scrollView must be on the view controller.")
            return nil
        }
        self.init(scrollView: scrollView, viewController: viewController)
    }
    
    public init(scrollView: UIScrollView, viewController: UIViewController, navigationBar: UIView? = nil) {
        super.init()
        scrollView.delegate = self
        __scrollView = scrollView
        self.viewController = viewController
        if let navigationBar = navigationBar ?? viewController.navigationController?.navigationBar {
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            navigationBar.addGestureRecognizer(gesture)
            navigationBarHeight = navigationBar.frame.height
            self.panGesture = gesture
        }
    }

    deinit {
        if let panGesture = panGesture {
            panGesture.view?.removeGestureRecognizer(panGesture)
        }
        
        __scrollView?.delegate = nil
        __scrollView = nil
    }
    
    fileprivate var targetViewController: UIViewController? {
        return viewController?.navigationController ?? viewController
    }
    
    private var haveShadowEffect: Bool {
        return backgroundEffect != nil || edgeShadow != nil
    }
    
    fileprivate func dismiss() {
        targetViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - shadow view
    
    private func makeBackgroundView() {
        deleteBackgroundView()
        guard let backgroundEffect = backgroundEffect else {
            return
        }
        let backgroundView = backgroundEffect.makeBackgroundView()
        backgroundView.frame = targetViewController?.view.bounds ?? .zero
        
        switch backgroundEffect.target {
        case .targetViewController:
            targetViewController?.view.addSubview(backgroundView)
            backgroundView.superview?.sendSubview(toBack: backgroundView)
            backgroundView.frame = targetViewController?.view.bounds ?? .zero
        case .presentingViewController:
            targetViewController?.presentingViewController?.view.addSubview(backgroundView)
            backgroundView.frame = targetViewController?.presentingViewController?.view.bounds ?? .zero
        }

        self.backgroundView = backgroundView
    }
    
    private func updateBackgroundView(rate: CGFloat) {
        guard let backgroundEffect = backgroundEffect else {
            return
        }
        
        backgroundEffect.applyEffect(view: backgroundView, rate: rate)
    }
    
    private func deleteBackgroundView() {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        targetViewController?.view.clipsToBounds = true
    }
    
    private func resetBackgroundView() {
        guard let backgroundEffect = backgroundEffect else {
            return
        }
        backgroundEffect.applyEffect(view: backgroundView, rate: 1.0)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            startDragging()
        case .changed:
            let diff = gesture.translation(in: gesture.view).y
            updateViewPosition(offset: diff)
            gesture.setTranslation(.zero, in: gesture.view)
        case .ended:
            finishDragging()
        default:
            break
        }
    }
    
    fileprivate func startDragging() {
        targetViewController?.view.layer.removeAllAnimations()
        backgroundView?.layer.removeAllAnimations()
        viewPositionY = 0.0
        makeBackgroundView()
        targetViewController?.view.applyEdgeShadow(edgeShadow)
        if haveShadowEffect {
            targetViewController?.view.clipsToBounds = false
        }
    }
    
    fileprivate func updateViewPosition(offset: CGFloat) {
        var addOffset: CGFloat = offset
        // avoid statusbar gone
        if viewPositionY >= 0 && viewPositionY < 0.05 {
            addOffset = min(max(-0.01, addOffset), 0.01)
        }
        viewPositionY += addOffset
        targetViewController?.view.frame.origin.y = max(0.0, viewPositionY)
        if case .some(.targetViewController) = backgroundEffect?.target {
            backgroundView?.frame.origin.y = -(targetViewController?.view.frame.origin.y ?? 0.0)
        }
        
        let targetViewOriginY: CGFloat = targetViewController?.view.frame.origin.y ?? 0.0
        let targetViewHeight: CGFloat = targetViewController?.view.frame.height ?? 0.0
        let rate: CGFloat = (1.0 - (targetViewOriginY / (targetViewHeight * dismissableHeightPercentage)))

        updateBackgroundView(rate: rate)
        targetViewController?.view.updateEdgeShadow(edgeShadow, rate: rate)
    }
    
    fileprivate func finishDragging() {
        let originY = targetViewController?.view.frame.origin.y ?? 0.0
        let dismissableHeight = (targetViewController?.view.frame.height ?? 0.0) * dismissableHeightPercentage
        if originY > dismissableHeight {
            deleteBackgroundView()
            targetViewController?.view.detachEdgeShadow()
            _ = dismissAction?() ?? dismiss()
        } else if originY != 0.0 {
            UIView.perform(.delete, on: [], options: [.allowUserInteraction], animations: { [weak self] in
                self?.targetViewController?.view.frame.origin.y = 0.0
                self?.resetBackgroundView()
                self?.targetViewController?.view.updateEdgeShadow(self?.edgeShadow, rate: 1.0)
            }) { [weak self] finished in
                if finished {
                    self?.deleteBackgroundView()
                    self?.targetViewController?.view.detachEdgeShadow()
                }
            }
        } else {
            self.deleteBackgroundView()
        }
        viewPositionY = 0.0
    }
    
    private static func viewControllerFromScrollView(_ scrollView: UIScrollView) -> UIViewController? {
        var responder: UIResponder? = scrollView
        while let r = responder {
            if let viewController = r as? UIViewController {
                return viewController
            }
            responder = r.next
        }
        return nil
    }
    
    // MARK: - delegates
    
    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        return delegateProxy as? UIScrollViewDelegate
    }
    
    public weak var tableViewDelegate: UITableViewDelegate? {
        return delegateProxy as? UITableViewDelegate
    }
    
    public weak var collectionViewDelegate: UICollectionViewDelegate? {
        return delegateProxy as? UICollectionViewDelegate
    }
    
    public weak var collectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout? {
        return delegateProxy as? UICollectionViewDelegateFlowLayout
    }
}

extension PullToDismiss: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dragging {
            let diff = -(scrollView.contentOffset.y - previousContentOffsetY)
            if scrollView.contentOffset.y < -scrollView.contentInset.top || (targetViewController?.view.frame.origin.y ?? 0.0) > 0.0 {
                updateViewPosition(offset: diff)
                scrollView.contentOffset.y = -scrollView.contentInset.top
            }
            previousContentOffsetY = scrollView.contentOffset.y
        }
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startDragging()
        dragging = true
        previousContentOffsetY = scrollView.contentOffset.y
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        finishDragging()
        dragging = false
        previousContentOffsetY = 0.0
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollViewDelegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
