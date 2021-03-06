//
//  RepositoryTask.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 02/03/21.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
