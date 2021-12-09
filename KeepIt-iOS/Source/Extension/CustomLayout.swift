//
//  customLayout.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/12/09.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewFlowLayout {

    weak var delegate: PinterestLayoutDelegate?

    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    private var cache: [UICollectionViewLayoutAttributes] = []

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else { return }

        let numberOfColums: Int = 2
        let cellPadding: CGFloat = 2
        let cellWidth: CGFloat = contentWidth / CGFloat(numberOfColums)

        let xOffSet: [CGFloat] = [0, cellWidth]
        var yOffSet: [CGFloat] = .init(repeating: 0, count: numberOfColums)

        var colum: Int = 0

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let imageHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 200
            let height = cellPadding * 2 + imageHeight

            let frame = CGRect(x: xOffSet[colum],
                               y: yOffSet[colum],
                               width: cellWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffSet[colum] = yOffSet[colum] + height

            colum = yOffSet[0] > yOffSet[1] ? 1 : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
