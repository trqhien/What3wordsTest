//
//  ImageLoaderServiceType.swift
//  What3WordsTest
//
//  Created by Hien Tran on 25/10/2023.
//

import Foundation
import Combine
import UIKit
import Kingfisher

protocol ImageLoaderServiceType {
    func loadImage(from path: String, size: ImageSize) -> AnyPublisher<KF.Builder?, Never>
}
