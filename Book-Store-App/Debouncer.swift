//
//  Debouncer.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 12.03.2024.
//

import Foundation

class Debouncer {
    var callback: (() -> Void)
    var delay: TimeInterval
    var timer: Timer?

    init(delay: TimeInterval, callback: @escaping (() -> Void)) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: false)
    }

    @objc func timerCallback() {
        callback()
    }
}
