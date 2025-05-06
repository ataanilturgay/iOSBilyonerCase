//
//  UIView+Extensions.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation

import UIKit

// MARK: - Autolayout Helpers

public extension UIView {

    /// Pins view to superview
    ///
    /// - Parameters:
    ///   - insets: Edge insets (defaults to .zero)
    ///   - shouldRespectSafeArea: Whether safe area should be respected or not (defaults to true)
    /// - Returns: Added layout constraints array. In leading, trailing, top, bottom order
    /// - Example: view.cuiPinToSuperView(with: UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0))
    /// - Warning: Uses insets.left for leading and insets.right for trailing everytime (even layout direction is right to left)
    @discardableResult
    func cuiPinToSuperview(
        with insets: UIEdgeInsets = .zero,
        shouldRespectSafeArea: Bool = true
        ) -> [NSLayoutConstraint] {

        guard superview != nil else {
            return []
        }

        var constraints: [NSLayoutConstraint] = []

        if let leading = cuiPinLeadingToSuperView(
            constant: insets.left,
            shouldRespectSafeArea: shouldRespectSafeArea
            ) {

            constraints.append(leading)
        }

        if let trailing = cuiPinTrailingToSuperView(
            constant: insets.right,
            shouldRespectSafeArea: shouldRespectSafeArea
            ) {
            constraints.append(trailing)
        }

        if let top = cuiPinTopToSuperView(
            constant: insets.top,
            shouldRespectSafeArea: shouldRespectSafeArea
            ) {
            constraints.append(top)
        }

        if let bottom = cuiPinBottomToSuperView(
            constant: insets.bottom,
            shouldRespectSafeArea: shouldRespectSafeArea
            ) {
            constraints.append(bottom)
        }

        return constraints
    }

    /// Pins leading anchor to superview's leading anchor
    ///
    /// - Parameters:
    ///   - constant: Constant to be applied between anchors
    ///   - shouldRespectSafeArea: Whether safe area should be respected or not (defaults to true)
    /// - Returns: Already activated `NSLayoutConstraint` instance or nil if view has no superview
    @discardableResult
    func cuiPinLeadingToSuperView(
        constant: CGFloat = 0.0,
        shouldRespectSafeArea: Bool = true
        ) -> NSLayoutConstraint? {

        guard let superview = superview else {
            return nil
        }

        translatesAutoresizingMaskIntoConstraints = false

        guard #available(iOS 11.0, *),
            superview.responds(to: #selector(getter: safeAreaLayoutGuide)) else {

                return leadingAnchor.cuiDock(
                    to: superview.leadingAnchor,
                    constant: constant
                )
        }

        return leadingAnchor.cuiDock(
            to: shouldRespectSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor,
            constant: constant
        )
    }

    /// Pins trailing anchor to superview's trailing anchor
    ///
    /// - Parameters:
    ///   - constant: Constant to be applied between anchors
    ///   - shouldRespectSafeArea: Whether safe area should be respected or not (defaults to true)
    /// - Returns: Already activated `NSLayoutConstraint` instance or nil if view has no superview
    @discardableResult
    func cuiPinTrailingToSuperView(
        constant: CGFloat = 0.0,
        shouldRespectSafeArea: Bool = true
        ) -> NSLayoutConstraint? {

        guard let superview = superview else {
            return nil
        }

        translatesAutoresizingMaskIntoConstraints = false

        guard #available(iOS 11.0, *),
            superview.responds(to: #selector(getter: safeAreaLayoutGuide)) else {

                return trailingAnchor.cuiDock(
                    to: superview.trailingAnchor,
                    constant: constant
                )
        }

        return trailingAnchor.cuiDock(
            to: shouldRespectSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor,
            constant: constant
        )
    }

    /// Pins top anchor to superview's top anchor
    ///
    /// - Parameters:
    ///   - constant: Constant to be applied between anchors
    ///   - shouldRespectSafeArea: Whether safe area should be respected or not (defaults to true)
    /// - Returns: Already activated `NSLayoutConstraint` instance or nil if view has no superview
    @discardableResult
    func cuiPinTopToSuperView(
        constant: CGFloat = 0.0,
        shouldRespectSafeArea: Bool = true
        ) -> NSLayoutConstraint? {

        guard let superview = superview else {
            return nil
        }

        translatesAutoresizingMaskIntoConstraints = false

        guard #available(iOS 11.0, *),
            superview.responds(to: #selector(getter: safeAreaLayoutGuide)) else {

                return topAnchor.cuiDock(
                    to: superview.topAnchor,
                    constant: constant
                )
        }

        return topAnchor.cuiDock(
            to: shouldRespectSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor,
            constant: constant
        )
    }

    /// Pins bottom anchor to superview's bottom anchor
    ///
    /// - Parameters:
    ///   - constant: Constant to be applied between anchors
    ///   - shouldRespectSafeArea: Whether safe area should be respected or not (defaults to true)
    /// - Returns: Already activated `NSLayoutConstraint` instance or nil if view has no superview
    @discardableResult
    func cuiPinBottomToSuperView(
        constant: CGFloat = 0.0,
        shouldRespectSafeArea: Bool = true
        ) -> NSLayoutConstraint? {

        guard let superview = superview else {
            return nil
        }

        translatesAutoresizingMaskIntoConstraints = false

        guard #available(iOS 11.0, *),
            superview.responds(to: #selector(getter: safeAreaLayoutGuide)) else {

                return bottomAnchor.cuiDock(
                    to: superview.bottomAnchor,
                    constant: constant
                )
        }

        return bottomAnchor.cuiDock(
            to: shouldRespectSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor,
            constant: constant
        )
    }

    /// Centers view in superview
    ///
    /// - Returns: Added layout constraints array (centerX, centerY order) or nil if it has no superview
    /// - Example: view.cuiCenterInSuperView()
    @discardableResult
    func cuiCenterInSuperview() -> [NSLayoutConstraint] {

        var constraints: [NSLayoutConstraint] = []

        if let centerXConstraint = cuiCenterHorizontallyInSuperView() {
            constraints.append(centerXConstraint)
        }

        if let centerYConstraint = cuiCenterVerticallyInSuperView() {
            constraints.append(centerYConstraint)
        }

        return constraints
    }

    /// Centers view horizontally in superview
    ///
    /// - Returns: Added layout constraint or nil if it has no superview
    /// - Example: view.cuiCenterHorizontallyInSuperView
    @discardableResult
    func cuiCenterHorizontallyInSuperView() -> NSLayoutConstraint? {

        guard let superview = superview else {
            return nil
        }

        translatesAutoresizingMaskIntoConstraints = false

        return centerXAnchor.cuiDock(to: superview.centerXAnchor)
    }

    /// Centers view veritcally in superview
    ///
    /// - Returns: Added layout constraint or nil if it has no superview
    /// - Example: view.cuiCenterVerticallyInSuperView
    @discardableResult
    func cuiCenterVerticallyInSuperView() -> NSLayoutConstraint? {

        guard let superview = superview else {
            return nil
        }

        translatesAutoresizingMaskIntoConstraints = false

        return centerYAnchor.cuiDock(to: superview.centerYAnchor)
    }
}

// MARK: - Layout Helpers

public extension UIView {

    /// Remove constraints from view
    func cuiRemoveAllConstraints() {

        removeConstraints(constraints)

        if let superview = superview {

            for constraint in superview.constraints {

                if (constraint.firstItem as? UIView) == self ||
                    (constraint.secondItem as? UIView) == self {
                    superview.removeConstraint(constraint)
                }
            }
        }
    }
}

// MARK: - Hierarchy Helpers

public extension UIView {

    /// Remove all subviews from view
    func cuiRemoveAllSubviews() {

        subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    /// Return all subviews of the view
    ///
    /// - Returns: Subviews is generic type as `Array`
    func cuiSubviews<T>() -> [T] {
        return subviews.compactMap {
            $0 as? T
        }
    }

    /// Return first subview of the view
    ///
    /// - Returns: Subview as generic type
    func cuiFirstSubview<T>() -> T? {
        return cuiSubviews().first
    }
}

// MARK: Animation Helpers

extension UIView {

    /// Animates alpha to given value
    ///
    /// - Parameters:
    ///   - alpha: Alpha value as `CGFloat`
    ///   - duration: Duration of the animation
    ///   - delay: Delay before the animations starts
    ///   - completion: Block executed when the animations end
    ///   - Example: view.animateToAlpha(1.0, duration: 0.5, delay: 0.2, options: .curveLinear, completion: nil)
    public func animateToAlpha(
        _ alpha: CGFloat,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0.0,
        options: UIView.AnimationOptions = .curveEaseInOut,
        completion: ((Bool) -> Void)? = nil
        ) {

        UIView.animate(
            withDuration: duration, delay: delay, options: options, animations: {
                self.alpha = alpha
        }, completion: completion)
    }

    func animateVisibility(_ isHidden: Bool, duration: TimeInterval = Global.Constants.Default.visibilityAnimationDuration) {

        if !isHidden {
            self.isHidden = isHidden
        }

        UIView.animate(withDuration: duration, animations: {

            self.alpha = isHidden ? 0.0 : 1.0
        }, completion: { (completed) in

            self.isHidden = completed && isHidden
        })
    }
}

public extension UIView {

    /// Apply shadow to view
    ///
    /// - Parameters:
    ///   - opacity: Opacity to be applied (defaults to 0)
    ///   - radius: Radius to be applied (defaults to 3)
    ///   - offset: Offset to be applied (defaults to .zero)
    ///   - color: Color to be applied (defaults to black)
    func applyShadow(
        opacity: Float = 0.0,
        radius: CGFloat = 3.0,
        offset: CGSize = .zero,
        color: CGColor = UIColor.black.cgColor
        ) {

        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

public extension NSLayoutDimension {

    /// Sets dimension to a constant value
    ///
    /// - Parameters:
    ///   - constant: Value to set
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view.widthAnchor.cuiSet(to: CGFloat(50.0))
    @discardableResult
    func cuiSet(
        to constant: CGFloat,
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(equalToConstant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Sets dimension to a constant value as less than or equal to
    ///
    /// - Parameters:
    ///   - constant: Value to set
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view.widthAnchor.cuiSet(lessThanOrEqualTo: CGFloat(50.0))
    @discardableResult
    func cuiSet(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(lessThanOrEqualToConstant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Sets dimension to a constant value as greater than or equal to
    ///
    /// - Parameters:
    ///   - constant: Value to set
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view.widthAnchor.cuiSet(greaterThanOrEqualTo: CGFloat(50.0))
    @discardableResult
    func cuiSet(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(greaterThanOrEqualToConstant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Sets dimension to another one with multiplier
    ///
    /// - Parameters:
    ///   - dimension: Dimension to set
    ///   - multiplier: Multiplier to be applied (defaults to 1)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.heightAnchor.cuiSet(to: view2.heightAnchor, multiplier: CGFloat(0.5))
    @discardableResult
    func cuiSet(
        to dimension: NSLayoutDimension,
        multiplier: CGFloat = CGFloat(1.0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(equalTo: dimension, multiplier: multiplier)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Sets dimension to another one with multiplier as less than or equal to
    ///
    /// - Parameters:
    ///   - dimension: Dimension to set
    ///   - multiplier: Multiplier to be applied (defaults to 1)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.heightAnchor.cuiSet(lessThanOrEqualTo: view2.heightAnchor, multiplier: CGFloat(0.5))
    @discardableResult
    func cuiSet(
        lessThanOrEqualTo dimension: NSLayoutDimension,
        multiplier: CGFloat = CGFloat(1.0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(lessThanOrEqualTo: dimension, multiplier: multiplier)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Sets dimension to another one with multiplier as greater than or equal to
    ///
    /// - Parameters:
    ///   - dimension: Dimension to set
    ///   - multiplier: Multiplier to be applied (defaults to 1)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.heightAnchor.cuiSet(greaterThanOrEqualTo: view2.heightAnchor, multiplier: CGFloat(0.5))
    @discardableResult
    func cuiSet(
        greaterThanOrEqualTo dimension: NSLayoutDimension,
        multiplier: CGFloat = CGFloat(1.0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(greaterThanOrEqualTo: dimension, multiplier: multiplier)
        cons.priority = priority
        cons.isActive = true
        return cons
    }
}

public extension NSLayoutXAxisAnchor {

    /// Docks anchor to another one
    ///
    /// - Parameters:
    ///   - anchor: Anchor to be dock
    ///   - constant: Constant to be applied (defaults to 0)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.leadingAnchor.cuiDock(to: view2.trailingAnchor, constant: CGFloat(30.0))
    @discardableResult
    func cuiDock(
        to anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = CGFloat(0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(equalTo: anchor, constant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Docks anchor to another one as less than or equal to
    ///
    /// - Parameters:
    ///   - anchor: Anchor to be dock
    ///   - constant: Constant to be applied (defaults to 0)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.leadingAnchor.cuiDock(lessThanOrEqualTo: view2.trailingAnchor, constant: CGFloat(30.0))
    @discardableResult
    func cuiDock(
        lessThanOrEqualTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = CGFloat(0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(lessThanOrEqualTo: anchor, constant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Docks anchor to another one as greater than or equal to
    ///
    /// - Parameters:
    ///   - anchor: Anchor to be dock
    ///   - constant: Constant to be applied (defaults to 0)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.leadingAnchor.cuiDock(greaterThanOrEqualTo: view2.trailingAnchor, constant: CGFloat(30.0))
    @discardableResult
    func cuiDock(
        greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = CGFloat(0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }
}

public extension NSLayoutYAxisAnchor {

    /// Docks anchor to another one
    ///
    /// - Parameters:
    ///   - anchor: Anchor to be dock
    ///   - constant: Constant to be applied (defaults to 0)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.bottomAnchor.cuiDock(to: view2.bottomAnchor, constant: CGFloat(30.0))
    @discardableResult
    func cuiDock(
        to anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = CGFloat(0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(equalTo: anchor, constant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Docks anchor to another one as less than or equal to
    ///
    /// - Parameters:
    ///   - anchor: Anchor to be dock
    ///   - constant: Constant to be applied (defaults to 0)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.leadingAnchor.cuiDock(lessThanOrEqualTo: view2.trailingAnchor, constant: CGFloat(30.0))
    @discardableResult
    func cuiDock(
        lessThanOrEqualTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = CGFloat(0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(lessThanOrEqualTo: anchor, constant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }

    /// Docks anchor to another one as greater than or equal to
    ///
    /// - Parameters:
    ///   - anchor: Anchor to be dock
    ///   - constant: Constant to be applied (defaults to 0)
    ///   - priority: Priority of the constraint (defaults to required)
    /// - Returns: Already activated NSLayoutConstraint instance
    /// - Example: view1.leadingAnchor.cuiDock(greaterThanOrEqualTo: view2.trailingAnchor, constant: CGFloat(30.0))
    @discardableResult
    func cuiDock(
        greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = CGFloat(0),
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }
}
