//
//  AsyncOperation.swift
//  VKClient
//
//  Created by Сергей Черных on 25.11.2021.
//

import UIKit

open class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    open override var isAsynchronous: Bool {
        true
    }
    
    override open var isReady: Bool {
        super.isReady && state == .ready
    }
    
    override open var isExecuting: Bool {
        state == .executing
    }
    
    override open var isFinished: Bool {
        state == .finished
    }
    
    
    open override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    
    override open func cancel() {
        super.cancel()
        state = .finished
    }
    
}
