//
//  EditVC.h
//  imageViewer
//
//  Created by YiMi on 2018/6/14.
//  Copyright © 2018 Baymax. All rights reserved.
//

#import "BaseViewController.h"

@interface EditVC : BaseViewController

/** <#注释#> */
@property (strong, nonatomic) NSString * imgPath;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
