//
//  ImageCacheManager.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/12/12.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init(){}
}
