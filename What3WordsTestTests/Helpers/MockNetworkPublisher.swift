//
//  MockNetworkPublisher.swift
//  What3WordsTestTests
//
//  Created by Hien Tran on 26/10/2023.
//

import Foundation
import Combine
@testable import What3WordsTest

final class MockNetworkPublisher<Output>: Publisher {

    typealias Failure = NetworkError
    
    public let output: Output
    
    public init(_ output: Output) {
        self.output = output
    }
    
    private final class Inner<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure {
        private var subscriber: S?
        private let output: S.Input

        init(subscriber: S, output: S.Input) {
            self.subscriber = subscriber
            self.output = output
        }

        // Implement the request function, which sends values to the subscriber
        func request(_ demand: Subscribers.Demand) {
            // Send the output to the subscriber
            _ = subscriber?.receive(output)
            subscriber?.receive(completion: .finished) // Finish the subscription
        }

        // Implement the cancel function, which cancels the subscription
        func cancel() {
            subscriber = nil
        }
    }
    
    internal func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Inner(subscriber: subscriber, output: output)
                subscriber.receive(subscription: subscription)
    }
}
