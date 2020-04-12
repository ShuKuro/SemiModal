//
//  SemiModalViewController.swift
//  SemiModal
//
//  Created by kuro on 2020/04/09.
//  Copyright © 2020 shukuro. All rights reserved.
//

import UIKit

class SemiModalViewController: UIViewController, OverCurrentTransitionable {
    
    var percentThreshold: CGFloat = 0.3
    var interactor = OverCurrentTransitioningInteractor()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frontView: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }

    func setupViews() {
        view.backgroundColor = .clear
        
        let frontGesture = UIPanGestureRecognizer(target: self, action: #selector(viewDidScroll(_:)))
        frontView.addGestureRecognizer(frontGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        backgroundView.addGestureRecognizer(gesture)
    }

    static func make() -> SemiModalViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SemiModal") as! SemiModalViewController
        
        return vc
    }

    @objc private func backgroundDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func viewDidScroll(_ sender: UIPanGestureRecognizer) {
        interactor.updateStatusShouldStartIfNeeded()
        handleTransitionGesture(sender)
    }
    
    @IBAction func apply(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SemiModalViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SemiModalViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch interactor.state {
        case .hasStarted, .shouldFinish:
            return interactor
        case .none, .shouldStart:
            return nil
        }
    }
}
