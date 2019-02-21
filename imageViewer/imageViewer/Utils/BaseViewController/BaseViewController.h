//
//  BaseViewController.h
//  qyshow
//
//  Created by 李志伟 on 16/12/7.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _BMVCDismissType {
    BMVCDismissType_pop  ,//返回
    BMVCDismissType_push  //跳到其他页面
} BMVCDismissType;

@interface BaseViewController : UIViewController

@property(nonatomic, assign) BOOL hideNav;
//navigationBar 文字颜色
@property(nonatomic, strong) UIColor *  tintColor;
//navigationBar 背景颜色
@property(nonatomic, strong) UIColor *  barTintColor;
//navigationBar 返回按钮颜色  在NavigationViewController中拦截判断 默认=nil 显示蓝色
@property(nonatomic, strong) UIColor *  barBackBtnColor;

//**是否隐藏导航栏横线 default = no*/
@property(nonatomic, assign) BOOL       hideNavBottonLine;
//是否显示导航栏横线
@property (strong, nonatomic) UIImageView * navBottonLineView;
//状态栏颜色
@property(nonatomic, assign) UIStatusBarStyle stateStyle;

@property(nonatomic, assign) NSInteger appearTimes;
//离开页面的方式
@property(nonatomic, assign) BMVCDismissType dismissType;

@property(nonatomic, strong) NSString * rightBarBtnTitle;
@property(nonatomic, strong) NSString * rightBarBtnImage;

@property(nonatomic, strong) UIButton * maskBlurView;

@property(nonatomic, strong) NSString *cacheKey;
//是否开启导航页面侧滑返回功能
@property(nonatomic, assign) BOOL canSlideBack;


//封装跳转 和 返回方法
-(void)pushViewController:(BaseViewController*)vc animated:(BOOL)animated;
//导航栏左侧返回按钮 全传nil为默认的 只穿color 修改返回箭头颜色
-(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image text:(NSString *)text color:(UIColor*)color;
//右上角按钮事件
-(void)rightBarBtnAction;

-(void)leftBarBtnAction;

-(void)popViewController;

-(void)closeKeybord;

//显示遮罩
-(void)showMaskBlurView;
//关闭遮罩
-(void)hideMaskBlurView;
//遮罩响应事件
-(void)maskViewAction;

//如果有接受通知 页面释放的时候需要调用
-(void)VCDelloc;
//当前最顶端的VC
+(BaseViewController*)currentVC;

@end
