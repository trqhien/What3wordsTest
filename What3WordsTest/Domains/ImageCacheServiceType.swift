//
//  ImageCacheServiceType.swift
//  What3WordsTest
//
//  Created by Hien Tran on 26/10/2023.
//

import Foundation
import UIKit
import ImageIO

// Declares in-memory image cache
protocol ImageCacheServiceType: AnyObject {
    // Returns the image associated with a given url
    func image(for url: URL) -> UIImage?
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    // Removes the image of the specified url in the cache
    func removeImage(for url: URL)
    // Removes all images from the cache
    func removeAllImages()
    // Accesses the value associated with the given url for reading and writing
    subscript(_ url: URL) -> UIImage? { get set }
}
