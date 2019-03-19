//
//  DDUnInvoiceSucceedVC.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/3/7.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDUnInvoiceSucceedVC.h"
#import "DDMakeInvoiceHistoryVC.h"
@interface DDUnInvoiceSucceedVC ()
@property (nonatomic,strong) UIImageView *succeedImgV;
@property (nonatomic,strong) UILabel *succeedL;
@end

@implementation DDUnInvoiceSucceedVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏本页导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    self.title=@"在线支付";
    [self creatUI];
    [self performSelector:@selector(jumpToHistory) withObject:self afterDelay:1.0];
}

-(void)jumpToHistory{
    //开票历史
    NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    NSMutableArray *detaiArray = [NSMutableArray array];
    for (UIViewController *vc in array) {
        if ([vc isKindOfClass:[self class]]) {
            [detaiArray addObject:vc];
        }
    }
    if (detaiArray.count >= 1) {
        for (int i=0; i<detaiArray.count; i++) {
            [array removeObject:detaiArray[i]];
        }
    }
    DDMakeInvoiceHistoryVC *historyVC = [DDMakeInvoiceHistoryVC new];
    historyVC.makeInvoiceHistoryType = MakeInvoiceHistoryTypePay;
    historyVC.type = self.type;
    historyVC.isFromExam = _isFromExam;
    [array addObject:historyVC];
    [self.navigationController setViewControllers:array animated:YES];
}

-(void)creatUI{
    [self.view addSubview:self.succeedImgV];
    [self.view addSubview:self.succeedL];
    [self.succeedImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WidthByiPhone6(93));
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(WidthByiPhone6(72));
    }];
    [self.succeedL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.succeedImgV.mas_bottom).offset(WidthByiPhone6(30));
        make.centerX.equalTo(self.view);
    }];
}
#pragma mark -- lazyload
-(UIImageView *)succeedImgV{
    if(!_succeedImgV){
        _succeedImgV = [[UIImageView alloc]initWithImage:DDIMAGE(@"paysuccess")];
    }
    return _succeedImgV;
}
-(UILabel *)succeedL{
    if(!_succeedL){
        _succeedL = [UILabel labelWithFont:KFontSize42 textString:@"支付成功" textColor:KColorFindingPeopleBlue textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _succeedL;
}
@end
