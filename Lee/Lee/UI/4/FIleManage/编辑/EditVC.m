//
//  EditVC.m
//  imageViewer
//
//  Created by YiMi on 2018/6/14.
//  Copyright © 2018 Baymax. All rights reserved.
//

#import "EditVC.h"
//#import "UIImageView+YYWebImage.h"
#import "TKImageView.h"

@interface EditVC (){
    UIImage *orignImg;
}

@property (strong, nonatomic) UIImage * myNewImg;

@property (strong, nonatomic) IBOutlet UIView *rollView;

@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;


@property (strong, nonatomic) IBOutlet UIView *cutBGView;
@property (weak, nonatomic) IBOutlet TKImageView *cutImgView;


@property (weak, nonatomic) IBOutlet UIView *updownSlideView;

@end

@implementation EditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.myNewImg = [UIImage imageWithContentsOfFile:self.imgPath];
    orignImg = self.imageView.image;
    self.imageView.image = self.myNewImg;

    self.cutImgView.backgroundColor = [UIColor blackColor];
    self.cutImgView.showMidLines = YES;
    self.cutImgView.needScaleCrop = YES;
    self.cutImgView.showCrossLines = NO;
    self.cutImgView.cornerBorderInImage = NO;
    self.cutImgView.cropAreaCornerWidth = 25;
    self.cutImgView.cropAreaCornerHeight = 25;
    self.cutImgView.minSpace = 30;
    self.cutImgView.cropAreaCornerLineColor = [UIColor whiteColor];
    self.cutImgView.cropAreaBorderLineColor = [UIColor whiteColor];
    self.cutImgView.cropAreaCornerLineWidth = 3;
    self.cutImgView.cropAreaBorderLineWidth = 1;
    self.cutImgView.cropAreaMidLineWidth = 25;
    self.cutImgView.cropAreaMidLineHeight = 3;
    self.cutImgView.cropAreaMidLineColor = [UIColor whiteColor];
    self.cutImgView.cropAreaCrossLineColor = [UIColor whiteColor];
    self.cutImgView.cropAreaCrossLineWidth = 1;
    self.cutImgView.initialScaleFactor = .8f;

    //下滑保存
    UISwipeGestureRecognizer *saveGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnAction:)];
    saveGes.direction = UISwipeGestureRecognizerDirectionDown;
    [_updownSlideView addGestureRecognizer:saveGes];

    //上滑取消
    UISwipeGestureRecognizer *cancelGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction:)];
    cancelGes.direction = UISwipeGestureRecognizerDirectionUp;
    [_updownSlideView addGestureRecognizer:cancelGes];
}


/** 1.向左翻转 */
- (IBAction)turnLeftBtnAction:(UIButton *)sender {
    self.myNewImg = [self rotate:UIImageOrientationLeft];
    self.imageView.image = self.myNewImg;
}

/** 2.裁剪 */
- (IBAction)cutImageBtnAction:(id)sender {
    self.cutImgView.toCropImage = self.myNewImg;
    self.cutImgView.cropAspectRatio = 0;
    self.cutBGView.frame = self.view.bounds;
    [self.view addSubview:self.cutBGView];
}

/** 3.水平翻转 */
- (IBAction)shuipingChangeBtnAction:(UIButton *)sender {
    self.myNewImg = [self rotate:UIImageOrientationUpMirrored];
    self.imageView.image = self.myNewImg;
}

//5.自由旋转
- (IBAction)returnBtnAction:(id)sender {
    self.sliderView.value = 0;
    self.rollView.frame = self.view.bounds;
    [self.view addSubview:self.rollView];
}

- (IBAction)sliderValueChangeAction:(UISlider*)sender {
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*(sender.value/-180.0));
    self.imageView.transform = transform;//旋转
}

- (IBAction)slideChangeSmall:(UIButton *)sender {
    if (sender.tag == 1) {
        self.sliderView.value = self.sliderView.value - 0.6;
    }else{
        self.sliderView.value = self.sliderView.value + 0.6;
    }
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*(self.sliderView.value/-180.0));
    self.imageView.transform = transform;//旋转
}


//取消 裁剪 或 旋转
- (IBAction)backZeroBtnAction:(UIButton *)sender {
    if (sender.tag == 0) {
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0);
        self.imageView.transform = transform;//旋转

        [_rollView removeFromSuperview];
    }else{
        [self.cutBGView removeFromSuperview];
    }
}

//4.还原
- (IBAction)rollBack:(id)sender {
    self.myNewImg = [UIImage imageWithContentsOfFile:self.imgPath];
    self.imageView.image = self.myNewImg;
}


//提交 裁剪 或 旋转
- (IBAction)comfirmCornerAction:(UIButton *)sender {
    if (sender.tag == 0) {
        self.myNewImg = [self imageRotatedByRadians:M_PI*(self.sliderView.value/-180.0)];
        self.sliderView.value = 0;
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.image = self.myNewImg;
        [_rollView removeFromSuperview];
    }else{
        self.myNewImg = [self.cutImgView currentCroppedImage];
        self.imageView.image = self.myNewImg;
        [self.cutBGView removeFromSuperview];
    }
}

//导航栏按钮
- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (IBAction)saveBtnAction:(id)sender {
    [UIImagePNGRepresentation(self.imageView.image) writeToFile:self.imgPath atomically:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_SaveImg object:nil userInfo:nil];
    [self dismissViewControllerAnimated:false completion:nil];
}

#pragma mark ----------  tool  ----------
- (UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.myNewImg.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;

    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);

    bnds = rect;

    switch (orient)
    {
        case UIImageOrientationUp:
            return self.myNewImg;

        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;

        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;

        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;

        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;

        default:
            return self.myNewImg;
    }

    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();

    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;

        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }

    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);

    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return copy;
}

/** 将图片旋转弧度radians */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.myNewImg.size.width, self.myNewImg.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);

    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);

    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.myNewImg.size.width / 2, -self.myNewImg.size.height / 2, self.myNewImg.size.width, self.myNewImg.size.height), [self.myNewImg CGImage]);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

/** 交换宽和高 */
static CGRect swapWidthAndHeight(CGRect rect){
    CGFloat swap = rect.size.width;

    rect.size.width = rect.size.height;
    rect.size.height = swap;

    return rect;
}




-(void)setMyNewImg:(UIImage *)myNewImg{
    _myNewImg = myNewImg;
    _sizeLab.text = [NSString stringWithFormat:@"%0.f * %0.f",myNewImg.size.width,myNewImg.size.height];
}



@end
