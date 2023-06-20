//
//  String+.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/20.
//

import Foundation

extension String {
    
    // MARK: - Method
    func capitalizeFirstLetter() -> String {
        
        return (self.prefix(1).uppercased() + self.lowercased().dropFirst())
    }
}
