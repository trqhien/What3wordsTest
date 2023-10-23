//
//  UITableView+Reusable.swift
//  What3WordsTest
//
//  Created by Hien Tran on 22/10/2023.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {}

extension UITableView {
    func register<T>(_: T.Type) where T : UITableViewCell {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(for type: T.Type, forIndexPath indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(type.reuseIdentifier) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}
