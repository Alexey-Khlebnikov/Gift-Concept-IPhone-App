//
//  Options.swift
//  GIFT_APP
//
//  Created by Alguz on 12/3/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation

/**
 Basic spring params.
 */
public struct SpringParams {

    /// The damping ratio from 0 to 1 for the spring animation as it approaches its quiescent state.
    let dampingRatio: CGFloat

    /// The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity.
    let velocity: CGFloat

    public init(dampingRatio: CGFloat, velocity: CGFloat) {
        self.dampingRatio = dampingRatio
        self.velocity = velocity
    }
}

/**
 Settings of spring animation for presenting and dismissing actions.
 */
public struct SpringSettings {
    let presentSpringParams: SpringParams
    let dismissSpringParams: SpringParams

    public init(presentSpringParams: SpringParams, dismissSpringParams: SpringParams) {
        self.presentSpringParams = presentSpringParams
        self.dismissSpringParams = dismissSpringParams
    }
}


/**
 Options that define menu transition settings.
 Struct lets user customize their transitioning animations: duration, content scale, visible content width, animationOptions, using spring animation or not and params if yes.
 */
public struct TransitionOptions {

    /**
     The duration of showing/hiding menu animation. Default value is 0.5.
     */
    public var duration: TimeInterval {
        willSet {
            if newValue < 0 {
                fatalError("Invalid `duration` value (\(newValue)). It must be non negative")
            }
        }
    }

    /**
     The scale factor of content menu item when the menu is opened. Default value is 0.88.
     */
    public var contentScale: CGFloat {
        willSet {
            if newValue < 0 {
                fatalError("Invalid `contentScale` value (\(newValue)). It must be non negative")
            }
        }
    }

    /// The width of visible part of content menu item when the menu is shown. Default value is 56 points.
    public var visibleContentWidth: CGFloat

    /// Defines if spring animation will be used on menu transition finishing. Default value is true.
    public var useFinishingSpringSettings = true

    /// Defines if spring animation will be used on menu transition cancelling (when user let draggable view to go back to the begining position). Default value is true.
    public var useCancellingSpringSettings = true

    /// Spring animation settings if `useFinishingSpringSettings` is set to true.
    public var finishingSpringSettings = SpringSettings(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.3),
                                                        dismissSpringParams: SpringParams(dampingRatio: 0.8, velocity: 0.3))

    /// Spring animation settings if `useCancellingSpringSettings` is set to true.
    public var cancellingSpringSettings = SpringSettings(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0),
                                                         dismissSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0))

    /// Regular view animation options. Default value is `curveEaseInOut`.
    public var animationOptions: UIView.AnimationOptions = .curveEaseInOut

    public init(duration: TimeInterval = 0.5, contentScale: CGFloat = 0.86, visibleContentWidth: CGFloat = 56.0) {
        self.duration = duration
        self.contentScale = contentScale
        self.visibleContentWidth = visibleContentWidth
    }
}
