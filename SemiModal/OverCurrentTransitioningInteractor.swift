//
//  OverCurrentTransitioningInteractor.swift
//  SemiModal
//
//  Created by kuro on 2020/04/10.
//  Copyright © 2020 shukuro. All rights reserved.
//

import UIKit

class OverCurrentTransitioningInteractor: UIPercentDrivenInteractiveTransition {
    enum State {
        case none
        case shouldStart
        case hasStarted
        case shouldFinish
    }
    
    var state: State = .none
    
    var startInteractionTranslationY: CGFloat = 0
    
    var startHandler: (() -> Void)?
    var resetHandler: (() -> Void)?
    
    override func cancel() {
        completionSpeed = percentComplete
        super.cancel()
    }
    
    override func finish() {
        completionSpeed = 1.0 - percentComplete
        super.finish()
    }
    
    func setStartInteractionTranslationY(_ translationT: CGFloat) {
        switch state {
        case .shouldStart:
            // interaction開始可能な際にinteraction開始までの間更新し続けることで、開始時のYを保持する
            startInteractionTranslationY = translationT
        case .hasStarted, .shouldFinish, .none:
            break
        }
    }
    
    func updateStatusShouldStartIfNeeded() {
        switch state {
        case .none:
            state = .shouldStart
            startHandler?()
        case .shouldStart, .hasStarted, .shouldFinish:
            break
        }
    }
    
    func reset() {
        state = .none
        startInteractionTranslationY = 0
        resetHandler?()
    }
}
