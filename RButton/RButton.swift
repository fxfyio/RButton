//
//  RButton.swift
//  RButton
//
//  Created by Eric on 5/16/23.
//

import UIKit

class RButton: UIButton {
    
    enum Style {
        case full
        case border(width: CGFloat)
    }
    
    public var style: Style = .full {
        didSet  {
            self.updateStyle()
        }
    }
    
    public var colors:[UIColor] = [UIColor.red, UIColor.blue] {
        didSet {
            self.addGradientLayer()
        }
    }
    
    public var cornerRadius: CGFloat = 16 {
        didSet {
            self.setCorner()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 16
        self.setCorner()
        
        let fview = UIView()
        fview.frame = CGRect(x: 4, y: 4, width: self.frame.width - 8, height: self.frame.height - 8)
        fview.backgroundColor = .black
        fview.layer.cornerRadius = 16
        
        self.backgroundColor = .black
    }
    
    private func setCorner() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    
    private var backgroundColorfulView: UIView?
    private var gradientLayer: CAGradientLayer?
    
    private func addGradientLayer() {
        self.backgroundColorfulView?.removeFromSuperview()
        self.backgroundColorfulView = UIView()
        self.insertSubview(self.backgroundColorfulView!, at: 0)
        if self.frame != .zero {
            self.setNeedsLayout()
        }
    }
    
    private var foregroundView: UIView?
    private var borderWidth: CGFloat = .zero
    func updateStyle() {
        switch self.style {
        case .border(width: let width):
            self.foregroundView = UIView()
            self.foregroundView?.backgroundColor = self.backgroundColor
            self.addSubview(self.foregroundView!)
            borderWidth = width
            self.setNeedsLayout()
        default:
            break
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let diagonal = sqrt(pow(self.frame.width, 2) + pow(self.frame.height, 2))
        self.backgroundColorfulView?.frame = CGRect(x: 0, y: 0, width: diagonal, height: diagonal)
        self.backgroundColorfulView?.layer.position = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        self.backgroundColorfulView?.addGradient(colors: self.colors, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        self.backgroundColorfulView?.rotateAround(pointToRotateAround: CGPoint(x: 0, y: self.frame.height / 2.0), degreesToRotate: 360, speed: 0.5, infinite: true)
        self.foregroundView?.frame = CGRect(x: borderWidth, y: borderWidth, width: self.frame.width - borderWidth * 2, height: self.frame.height - borderWidth * 2)
        self.foregroundView?.layer.cornerRadius = self.layer.cornerRadius
    }
}


extension UIView {
    
    func rotateAround(pointToRotateAround: CGPoint, degreesToRotate: Double, speed: Double, infinite: Bool) {
        self.layer.removeAllAnimations()
        
        let radiansToRotate = CGFloat(degreesToRotate * .pi / 180.0)
        
        self.layer.transform = CATransform3DIdentity
        
        var transform = CATransform3DMakeTranslation(-pointToRotateAround.x, -pointToRotateAround.y, 0.0)
        transform = CATransform3DRotate(transform, radiansToRotate, 0.0, 0.0, 1.0)
        transform = CATransform3DTranslate(transform, pointToRotateAround.x, pointToRotateAround.y, 0.0)
        
        var duration = 1.0
        if speed > 0 {
            duration = 1.0 / speed
        }
        
        if infinite {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.toValue = NSNumber(value: .pi * 2.0)
            animation.duration = duration
            animation.repeatCount = MAXFLOAT
            self.layer.add(animation, forKey: "rotationAnimation")
        } else {
            UIView.animate(withDuration: duration) {
                self.layer.transform = transform
            }
        }
    }
}


extension UIView {
    
    @discardableResult
    func addGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        for layer in self.layer.sublayers ?? [] where layer is CAGradientLayer {
            layer.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
}


extension UIView {
    
    @discardableResult
    func addGradientLayer(from startColor: UIColor, to endColor: UIColor, direction: GradientDirection) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
    enum GradientDirection {
        case horizontal
        case vertical
    }
}
