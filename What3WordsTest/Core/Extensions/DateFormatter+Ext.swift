//
//  DateFormatter+Ext.swift
//  What3WordsTest
//
//  Created by Hien Tran on 23/10/2023.
//

import Foundation

extension DateFormatter {
    static var yyyyMMdd: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
