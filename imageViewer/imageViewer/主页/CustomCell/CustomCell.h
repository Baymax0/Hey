//
//  CustomCell.h
//  imageViewer
//
//  Created by Baymax on 17/9/19.
//  Copyright © 2017年 Baymax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAnimatedImageView.h"
@interface CustomCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImgView;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imgView;

@property (weak, nonatomic) IBOutlet UIView *FileView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLab;

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGes;

@property (weak, nonatomic) IBOutlet UILabel *gifLab;

@property (assign, nonatomic) BOOL isFile;

@end
