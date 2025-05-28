//
//  UIImage+.swift
//  LightOn
//
//  Created by 신정욱 on 5/28/25.
//

import UIKit

extension UIImage {
    /// 비율 유지하며 이미지 리사이즈
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        // 이미지 비율 구하는 공식
        // (original height / original width) x new width = new height
        
        let newHeight = (size.height/size.width) * newWidth
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let resizedImage = render.image { _ in draw(in: CGRect(origin: .zero, size: size)) }
        
        return resizedImage
    }
}
