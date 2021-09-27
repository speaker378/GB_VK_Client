//
//  Loader.swift
//  VKClient
//
//  Created by Сергей Черных on 26.09.2021.
//

import UIKit

class Loader {
    
    weak var view: UIView!
    
    private let stackView: UIStackView = {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
            return $0
        }(UIStackView())
    
    private let circle1 = UIView()
    private let circle2 = UIView()
    private let circle3 = UIView()
    private lazy var circles = [circle1, circle2, circle3]
    
    init(rootView: UIView) {
        self.view = rootView
        setup()
    }
    
    private func setup() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circles.forEach {
            $0.layer.cornerRadius = 20/2
            $0.layer.masksToBounds = true
            $0.backgroundColor = .none
            stackView.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }
    
    func animate(action: @escaping ()-> Void) {
            self.view.isUserInteractionEnabled = false
            let jumpDuration: Double = 0.33
            let delayDuration: Double = 0
            let totalDuration = delayDuration + jumpDuration * 2

            let jumpRelativeDuration = jumpDuration / totalDuration
            let jumpRelativeTime = delayDuration / totalDuration
            let fallRelativeTime = (delayDuration + jumpDuration) / totalDuration

            for (index, circle) in circles.enumerated() {
                circle.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                let delay = jumpDuration*2 * TimeInterval(index) / TimeInterval(circles.count)
                UIView.animateKeyframes(withDuration: totalDuration, delay: delay, options: [.autoreverse], animations: {
                    UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
                        circle.frame.origin.y -= 20
                    }
                    UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
                        circle.frame.origin.y += 20
                    }
                },
                completion: {_ in
                    if index == self.circles.count - 1 {
                        self.circles.forEach{ $0.backgroundColor = .none }
                        self.view.isUserInteractionEnabled = true
                        action()
                    }
                } )
            }
        }
}
