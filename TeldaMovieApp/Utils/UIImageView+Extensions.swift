//
//  UIImageView+Extensions.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL?) {
        guard let url = url else {
            self.image = nil
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }.resume()
    }
}
