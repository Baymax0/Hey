//
//  MyCollectionViewLayout.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

protocol MyCollectionViewLayoutDelegate {
    // 返回index位置下的item的高度
    func waterFallLayout(layout:UICollectionViewFlowLayout,index :NSInteger,width :CGFloat) ->CGFloat
    // 返回瀑布流显示的列数
    func columnCountOfWaterFallLayout(layout:UICollectionViewFlowLayout) ->NSInteger
}

class MyCollectionViewLayout: UICollectionViewFlowLayout {

    var delegate :MyCollectionViewLayoutDelegate?
    var attributesArray = [UICollectionViewLayoutAttributes]()//布局信息存储，防止下拉看到二次区域时，多次返回布局信息。
    var columnHeights   = Array<Float>()//存储当前行的列的高度信息。
    var columnCount :Int = 2//默认列数
    var edgeInsets :UIEdgeInsets = UIEdgeInsets(top:5, left: 10, bottom:10, right:10)
    var columnMargin :CGFloat   = 10//列距
    var rowMargin :CGFloat      = 10//行距

    override func prepare() {
        super.prepare()
        //初始化最大高度数据集合
        columnHeights = Array<Float>()
        self.columnCount = (self.delegate?.columnCountOfWaterFallLayout(layout: self))!
        if self.columnCount <= 0 {
            return;
        }
        for _ in 0..<columnCount {
            columnHeights.append(Float(self.edgeInsets.top))
        }
        //初始化布局信息数据源
        attributesArray = [UICollectionViewLayoutAttributes]()
        let cellCount = self.collectionView!.numberOfItems(inSection: 0)
        for i in 0..<cellCount {
            let indexPath = NSIndexPath.init(item: i, section: 0)
            let attributes = self.layoutAttributesForItem(at: indexPath as IndexPath)
            attributesArray.append(attributes!)
        }
    }

    // 所有单元格位置属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributesArray
    }

    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let collectionViewWidth :CGFloat = self.collectionView!.frame.size.width
        let width :CGFloat = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (CGFloat(self.columnCount) - 1) * self.columnMargin) / CGFloat(self.columnCount);
        // 计算当前item应该摆放在第几列(计算哪一列高度最短)
        var minColumn :Int = 0//默认是第0列
        var minHeight :Float = MAXFLOAT
        // 遍历找出最小高度的列，在最小列的下面新增。
        for (index,value) in self.columnHeights.enumerated() {
            if minHeight > value {
                minHeight = value
                minColumn = index
            }
        }
        let x :CGFloat = self.edgeInsets.left + CGFloat(minColumn) * CGFloat(width + self.columnMargin)
        let y :CGFloat = CGFloat(minHeight) + self.rowMargin
        let height :CGFloat = (self.delegate?.waterFallLayout(layout: self, index: indexPath.row, width: width))!
        attribute.frame = CGRect(x: x, y: y, width: width, height: height)
        // 更新数组中的最短列的高度
        self.columnHeights[minColumn] = Float(y + height)
        return attribute
    }

    // 内容区域总大小，不是可见区域
    override var collectionViewContentSize: CGSize{
        //每次加载时，重新计算最大高度。防止多次下拉时看不到更多区域。
        var maxHeight :Float = 0
        for (_,value) in self.columnHeights.enumerated() {
            if value > maxHeight {
                maxHeight = value
            }
        }
        return CGSize(width: 0, height: CGFloat(maxHeight) + self.edgeInsets.top)
    }

}
