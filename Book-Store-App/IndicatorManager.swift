//
//  IndicatorManager.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 13.03.2024.
//

import UIKit

class IndicatorManager {
    static let shared = IndicatorManager()
    func createActivityIndicator(view: UIView) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .systemGray6
        indicator.layer.opacity = 0.6
        indicator.isHidden = false
        indicator.startAnimating()
        
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: view.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
            
        ])
        return indicator
    }
}
