//
//  UIImageView+Utils.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 25/01/21.
//

import UIKit
import SkeletonView

extension UIImageView {
    func load(url: URL, queue: DispatchQueue = DispatchQueue.global(), asTemplate: Bool = false) {
        isSkeletonable = true
        showAnimatedSkeleton()
        queue.async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.hideSkeleton()
                        self?.image = asTemplate ? image.withRenderingMode(.alwaysTemplate) : image
                    }
                }
            }
        }
    }
}
