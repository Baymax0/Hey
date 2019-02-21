//
//  CustomCell.m
//  imageViewer
//
//  Created by Baymax on 17/9/19.
//  Copyright © 2017年 Baymax. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(void)setIsFile:(BOOL)isFile{
    if (isFile) {
        _FileView.hidden = NO;
        _imgView.hidden = YES;
    }else{
        _FileView.hidden = YES;
        _imgView.hidden = NO;
    }
    _isFile = isFile;
}

@end
