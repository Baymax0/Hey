//
//  MainVC.m
//  imageViewer
//
//  Created by YiMi on 2018/6/12.
//  Copyright © 2018 Baymax. All rights reserved.
//

#import "MainVC.h"
#import "CustomCell.h"
#import "EZImageBrowserKit.h"
#import "YYImage.h"
#import "YYAnimatedImageView.h"
#import "UIImageView+YYWebImage.h"

#import "YYCacheManager.h"
#import "EditVC.h"
#import "AlertView.h"
#import "VideoPlayVC.h"

#import <WebKit/WebKit.h>

//应用程序的屏幕宽度
#define KWindowW    [UIScreen mainScreen].bounds.size.width
//应用程序的屏幕宽度
#define KWindowH    [UIScreen mainScreen].bounds.size.height

#define MoreViewY    20
#define pageNum    14
#define CellH   120

@interface MainVC ()<EZImageBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSInteger currentIndex;

    NSString *lastName;

    NSMutableDictionary *lastVisitFile;

    BOOL loadSafe;
}

@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnW;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;

@property (weak, nonatomic) IBOutlet UILabel *fileNameLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** EZImageBrowser *browser */
@property (strong, nonatomic) EZImageBrowser *browser;

@property (strong, nonatomic) NSFileManager * fileManager;
//当前路径 层级 数组
@property (strong, nonatomic) NSMutableArray * directArr;
//路径字符串
@property (strong, nonatomic) NSString * directPath;
//当前路径下的所有文件
@property (strong, nonatomic) NSMutableArray* subFiles;


//设置界面
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UISwitch *onlyGifSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hideGifSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *sortableSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rowNumControl;
@property (weak, nonatomic) IBOutlet UILabel *lastVisitLab;



@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置的初始化参数
    _onlyGifSwitch.on = NO;
    _hideGifSwitch.on = NO;
    _rowNumControl.selectedSegmentIndex = [Utils rowNumIndex];

    loadSafe = YES;

    _fileManager = [NSFileManager defaultManager];

    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

    //默认路径为 文稿 路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.directArr = [NSMutableArray arrayWithObject:docDir];
    _backBtnW.constant = 0;
    _backImgView.alpha = 0;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData)name:KNotification_SaveImg object:nil];

    [self reloadData];
    [self loadCacheSetting];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(safeLogin)name:KNotification_SafeLogin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unsafeLogin)name:KNotification_UnSafeLogin object:nil];
}

-(void)safeLogin{
    if (loadSafe != YES) {
        loadSafe = YES;
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.directArr = [NSMutableArray arrayWithObject:docDir];
        [self reloadData];
    }
}

//不安全登录
-(void)unsafeLogin{
    if (loadSafe == NO) {
        return;
    }
    loadSafe = NO;
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.directArr = [NSMutableArray arrayWithObject:docDir];
    [self reloadData];
}

//加载缓存设置
-(void)loadCacheSetting{
    lastVisitFile = [[YYCacheManager unLoginShare] getCacheForKey:KCacheKey_LastVisitFileDic];
    if (!lastVisitFile) {
        lastVisitFile = [NSMutableDictionary dictionary];
    }

    NSNumber *sortable = [[YYCacheManager unLoginShare] getCacheForKey:KCacheKey_Sort];
    if (!sortable) {
        sortable = @(NO);
    }
    _sortableSwitch.on = sortable.boolValue;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_browser.superview) {
        [_browser removeFromSuperview];
        _browser = nil;

        [self showIndex:currentIndex];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[YYCacheManager unLoginShare] setCache:lastVisitFile forKey:KCacheKey_LastVisitFileDic];
}

-(void)showIndex:(NSInteger)index{
    _browser = [[EZImageBrowser alloc] init];
    _browser.supportLongPress = YES;
    _browser.superView = self.view;
    [_browser setDelegate:self];
    [_browser showWithCurrentIndex:index  completion:nil];
}

//刷新数据
-(void)reloadData{
    [self loadSubFile];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    if (self.directArr.count == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            _backBtnW.constant = 0;
            _backImgView.alpha = 0;
            _fileNameLab.text = @"文稿";
            [_naviView layoutIfNeeded];
        }];
    }else{
        _backBtnW.constant = 40;
        _backImgView.alpha = 1;
        [_naviView layoutIfNeeded];
        _fileNameLab.text = self.directArr.lastObject;
    }
}

#pragma mark - layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat blank = 5;
    NSInteger num = _rowNumControl.selectedSegmentIndex+2;
    CGFloat itemW = (kMainScreenWidth - blank * (num-1)-5*2)/num;
    return CGSizeMake(itemW-1, CellH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subFiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imgView.autoPlayAnimatedImage = NO;
    NSString *name = self.subFiles[indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.directPath,name];
    //文件夹
    if ([Utils isDirectory:path]) {
        [cell setIsFile:YES];
        cell.fileNameLab.text = name;
        cell.FileView.tag = indexPath.row;
        cell.customImgView.image = [UIImage imageNamed:@"文件夹"];
    }else if ([Utils isVideoFile:path]) {
        [cell setIsFile:YES];
        cell.fileNameLab.text = name;
        cell.FileView.tag = indexPath.row;
        cell.customImgView.image = [UIImage imageNamed:@"视频"];
    }
    //图片
    else{
        [cell setIsFile:NO];
        [cell.imgView yy_setImageWithURL:[NSURL fileURLWithPath:path] placeholder:nil options:YYWebImageOptionRefreshImageCache  completion:nil];
//        [cell.imgView yy_setImageWithURL:[NSURL fileURLWithPath:path] placeholder:nil options:YYWebImageOptionRefreshImageCache completion:nil];
    }
    if (!cell.longPressGes) {
        cell.longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        cell.longPressGes.minimumPressDuration = 0.2;
        [cell addGestureRecognizer:cell.longPressGes];
    }
    if ([path containsString:@".gif"]) {
        cell.gifLab.hidden = NO;
    }else{
        cell.gifLab.hidden = YES;
    }
    cell.tag = indexPath.item;
    return cell;
}

-(YYImage *)imageWithIndex:(NSInteger)index{
    NSString *imgName = self.subFiles[index];
    NSString *str = [NSString stringWithFormat:@"%@/%@",self.directPath,imgName];
    YYImage *imgM = [YYImage imageWithContentsOfFile:str];
    return imgM;
}

//点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = self.subFiles[indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.directPath,name];
    //文件夹
    if ([Utils isVideoFile:path]) {
        //播放视频
        VideoPlayVC * vc = [[VideoPlayVC alloc] init];
        vc.videoURL = [NSURL fileURLWithPath:path];
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([Utils isDirectory:path]){
        //刷新页面
        [self.directArr addObject:name];
        [self reloadData];
    }else{
        [self showIndex:indexPath.item];
    }
}

#pragma mark - EZImageBrowserDelegate
- (NSInteger)numberOfCellsInImageBrowser:(EZImageBrowser *)imageBrowser{
    return self.subFiles.count;
}

- (EZImageBrowserCell *)imageBrowser:(EZImageBrowser *)imageBrowser cellForRowAtIndex:(NSInteger )index{
    EZImageBrowserCell *cell = [imageBrowser dequeueReusableCell];
    if (!cell) {
        cell = [[EZImageBrowserCell alloc] init];
    }
    cell.loadingView.hidden = YES ;
    cell.imageView.image = [self imageWithIndex:index];

    NSString *imgName = self.subFiles[index];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.directPath,imgName];
    if ([Utils isVideoFile:path]) {
        cell.imageView.image = [UIImage imageNamed:@"视频"];
    }else if ([Utils isDirectory:path]){
        cell.imageView.image = [UIImage imageNamed:@"文件夹"];
    }else{
        [cell.imageView yy_setImageWithURL:[NSURL fileURLWithPath:path] placeholder:nil options:YYWebImageOptionRefreshImageCache|YYWebImageOptionSetImageWithFadeAnimation  completion:nil];
    }
    return cell;
}

- (CGSize)imageBrowser:(EZImageBrowser *)imageBrowser  imageViewSizeForItemAtIndex:(NSInteger)index{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    return size;
}

- (void)imageBrowser:(EZImageBrowser *)imageBrowser didDisplayingCell:(EZImageBrowserCell *)cell atIndex:(NSInteger)index{
    CGFloat needY = (index/3)*(CellH+5);
    CGFloat currentY = self.collectionView.contentOffset.y;
    CGFloat wucha = 70;


    if (currentY > (needY+wucha) || currentY < (needY-(kMainScreenHeight-95-CellH+wucha))) {
        index = index - 2*(_rowNumControl.selectedSegmentIndex+2);
        if (index<0) {
            index = 0;
        }
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}

- (UIView *)imageBrowser:(EZImageBrowser *)imageBrowser fromViewForItemAtIndex:(NSInteger)index{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UIView *cell = [self.collectionView cellForItemAtIndexPath:scrollIndexPath];
    return cell;
}

#pragma mark ----------  事件  ----------
//返回上一级
- (IBAction)backUpLevel:(UIButton *)sender {
    if (self.directArr.count >1) {
        [self.directArr removeLastObject];
    }
    [self reloadData];
}

- (IBAction)settingBtnAction:(id)sender {
    CGFloat x = 90;
    _settingView.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth-x, kMainScreenHeight);
    [self showMaskBlurView];

    NSString *text = lastVisitFile[[self pathKey]];
    text = text == nil?@"无记录":text;

    _lastVisitLab.text = text;

    [[Utils keyWindow] addSubview:_settingView];
    [UIView animateWithDuration:0.2 animations:^{
        _settingView.frame = CGRectMake(x, 0, kMainScreenWidth-x, kMainScreenHeight);
    } completion:^(BOOL finished) {
    }];
}

-(void)maskViewAction{
    [self hideMaskBlurView];
    CGFloat x = 90;

    [[Utils keyWindow] addSubview:_settingView];
    [UIView animateWithDuration:0.2 animations:^{
        _settingView.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth-x, kMainScreenHeight);
    } completion:^(BOOL finished) {
        [_settingView removeFromSuperview];
    }];
}

- (IBAction)showGifBtnAction:(id)sender {
    [self reloadData];
}

- (IBAction)changeNumInRowAction:(UISegmentedControl *)sender {
    [Utils setRowNumIndex:sender.selectedSegmentIndex];
    [self reloadData];
}

- (IBAction)sortableBtnAction:(id)sender {
    [[YYCacheManager unLoginShare] setCache:@(_sortableSwitch.isOn) forKey:KCacheKey_Sort];
    [self reloadData];
}

-(void)longPressAction:(UIGestureRecognizer*)sender{
    NSInteger tag = sender.view.tag;
    NSString *name = self.subFiles[tag];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.directPath,name];


    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    //编辑
    UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EditVC *editVC = [[EditVC alloc] init];
        editVC.imgPath = path;
        editVC.view.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, kMainScreenHeight);
        [self presentViewController:editVC animated:YES completion:nil];
    }];
    
    //标记
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"标记" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       lastVisitFile[[self pathKey]] = name;
        [[YYCacheManager unLoginShare] setCache:lastVisitFile forKey:KCacheKey_LastVisitFileDic];
        NSString * str = [NSString stringWithFormat:@"已标记: %@",name];
        [HUD showTitle:str];
    }];

    //删除
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_fileManager removeItemAtPath:path error:nil];
        NSIndexPath *indexPath = [_collectionView indexPathForCell:(CustomCell*)sender.view];
        [self.collectionView performBatchUpdates:^{
            // 删除数据源
            [self.subFiles removeObjectAtIndex:indexPath.row];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }completion:^(BOOL finished){
            [self.collectionView reloadData];
        }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [actionSheetController addAction:copyAction];
    [actionSheetController addAction:renameAction];
    [actionSheetController addAction:deleteAction];
    [actionSheetController addAction:cancelAction];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)imageBrowser:(EZImageBrowser *)imageBrowser didLongPressCellAtIndex:(NSInteger)index{
    NSInteger tag = index;
    NSString *name = self.subFiles[tag];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.directPath,name];


    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    //编辑
    UIAlertAction *editAction2 = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EditVC *editVC = [[EditVC alloc] init];
        editVC.imgPath = path;
        editVC.view.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, kMainScreenHeight);
        currentIndex = index;
        [self presentViewController:editVC animated:YES completion:nil];
    }];

    //标记
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"标记" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        lastVisitFile[[self pathKey]] = name;
        [[YYCacheManager unLoginShare] setCache:lastVisitFile forKey:KCacheKey_LastVisitFileDic];
        NSString * str = [NSString stringWithFormat:@"已标记: %@",name];
        [HUD showTitle:str];
    }];

    //删除
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [AlertView showConfirmAlertIn:self title:@"提醒" detail:@"确定删除？" block:^{
            currentIndex = index;
            [_fileManager removeItemAtPath:path error:nil];
            // 删除数据源
            [self reloadData];

            [_browser removeFromSuperview];
            _browser = nil;
            if (currentIndex>=self.subFiles.count) {
                currentIndex = currentIndex-1;
            }
            [self showIndex:currentIndex-1];
//        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];

    [actionSheetController addAction:copyAction];
    [actionSheetController addAction:editAction2];
    [actionSheetController addAction:deleteAction];
    [actionSheetController addAction:cancelAction];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (IBAction)jumpLastVisitBtnAction:(id)sender {
    [self maskViewAction];

    NSString * name_temp = lastVisitFile[[self pathKey]];
    NSInteger index = -1;
    if (name_temp) {
        for (int i =0 ; i<self.subFiles.count; i++) {
            NSString *name = self.subFiles[i];
            if ([name isEqualToString:name_temp]) {
                index = i;
                break;
            }
        }
        //跳转
        if (index != -1) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }

    }
}


#pragma mark ----------  get set ----------

-(NSMutableArray *)directArr{
    if (!_directArr) {
        _directArr = [NSMutableArray array];
    }
    return _directArr;
}

-(NSString *)directPath{
    NSString *str;
    if (self.directArr.count==1) {
        str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    if (self.directArr.count>1) {
        str = [self.directArr componentsJoinedByString:@"/"];
    }
    _directPath = str;
    return _directPath;
}

//读取子文件 过滤
-(void)loadSubFile{
    self.subFiles = [_fileManager contentsOfDirectoryAtPath:self.directPath error:nil].mutableCopy;
    //过滤
    if (self.subFiles.count > 0) {
        for (int i = 0; i<self.subFiles.count; i++) {
            //过滤隐藏文件
            NSString *obj = self.subFiles[i];
            if ([obj hasPrefix:@"."]) {
                [_subFiles removeObject:obj];
                i--;
                continue;
            }
            //过滤隐藏文件
            if (!loadSafe) {
                if ([obj containsString:unSafeKey]) {
                    [_subFiles removeObject:obj];
                    i--;
                    continue;
                }
            }

            //判断过滤gif
            NSString *path = [NSString stringWithFormat:@"%@/%@",self.directPath,obj];
            if ([Utils isDirectory:path]) {
                [self.subFiles removeObject:obj];
                [self.subFiles insertObject:obj atIndex:0];
            }else{
                if (_hideGifSwitch.on){
                    if ([obj hasSuffix:@".gif"]) {
                        [_subFiles removeObject:obj];
                        i--;
                    }
                }else{
                    if (_onlyGifSwitch.on) {
                        if (![obj hasSuffix:@".gif"]) {
                            [_subFiles removeObject:obj];
                            i--;
                        }
                    }
                }
                
            }
        }
    }
    //排序
    if (_sortableSwitch.isOn) {
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];//yes升序排列，no,降序排列
        NSArray *temp = self.subFiles.copy;
        self.subFiles = [temp sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]].mutableCopy;
    }
}

//获得当前的目录结构
-(NSString *)pathKey{
    NSString *str;
    if (self.directArr.count==1) {
        str = @"/Documents";
    }
    if (self.directArr.count>1) {
        NSMutableArray *temp = self.directArr.mutableCopy;
        [temp removeObjectAtIndex:0];
        str = [temp componentsJoinedByString:@"/"];
        str = [NSString stringWithFormat:@"/Documents/%@",str];
    }

    return str;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
