//
//  DDValidTimeSummaryVC.m
//  GongChengDD
//
//  Created by csq on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDValidTimeSummaryVC.h"
#import "DDEnterpriseCertificateSummaryVC.h"
#import "DDPersonalCertificateSummaryVC.h"
#import "DDNavigationUtil.h"
//#import "DDServiceWebViewVC.h"
#import "DDExamineTrainingVC.h"
@interface DDValidTimeSummaryVC ()<UIScrollViewDelegate>{
    NSInteger _selectIndex;
}
@property(nonatomic,strong)UISegmentedControl * Segment;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)DDEnterpriseCertificateSummaryVC *enterpriseCertificateSummaryVC;
@property(nonatomic,strong)DDPersonalCertificateSummaryVC *personalCertificateSummaryVC;

@end

@implementation DDValidTimeSummaryVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //还原导航底部线条颜色
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex = self.index;
    self.navigationItem.title = @"有效期汇总";
    self.view.backgroundColor = kColorBackGroundColor;
    if ([_type isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"证书" target:self action:@selector(leftButtonClick)];
    }
    else{
        self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    }
    if (self.index == 1) {
        if([_isOpen integerValue] != 0){
            self.navigationItem.rightBarButtonItem = [DDUtils rightbuttonItemWithTitle:@"考试培训" titleColor:KColorFindingPeopleBlue target:self action:@selector(rightButtonClick)];
        }
    }
    [self createSegment];
    [self createScrollView];
    [self setUpDefaultViewControll];
}
-(void)rightButtonClick{
    if (_selectIndex == 0) {
//        DDServiceWebViewVC * checkVC = [DDServiceWebViewVC new];
//        checkVC.hostUrl = @"http://gcdd.koncendy.com/apphs/enterprise_service/";
//        [self.navigationController pushViewController:checkVC animated:YES];
    }else{
        DDExamineTrainingVC * vc = [[DDExamineTrainingVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
       
    }
}
-(void)createSegment{
    UIView * SegmentView = [[UIView alloc]init];
    SegmentView.backgroundColor = kColorNavBarGray;
    [self.view addSubview:SegmentView];
    
    [SegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@60);
    }];
    
    UIView * lineView = [[UIView alloc]init];
    [SegmentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(SegmentView).with.offset(0);
        make.right.equalTo(SegmentView).with.offset(0);
        make.left.equalTo(SegmentView).with.offset(0);
        make.height.mas_equalTo(@0.5);
        
    }];
    lineView.backgroundColor = kColorNavBottomLineGray;
    
    NSArray * segmentArray = @[@"企业证书",@"人员证书"];
    _Segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
    [SegmentView addSubview:_Segment];
    [_Segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SegmentView).with.offset(12.5);
        make.right.equalTo(SegmentView).with.offset(-25);
        make.left.equalTo(SegmentView).with.offset(25);
        make.height.mas_equalTo(@35);
        
    }];
   
    _Segment.tintColor = kColorBlue;
    UIColor *segmentColor = kColorBlue;
    
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObjectsAndKeys:segmentColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [_Segment setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    _Segment.layer.cornerRadius = 5;
    _Segment.layer.masksToBounds = YES;
    _Segment.layer.borderColor =kColorBlue.CGColor;
    _Segment.layer.borderWidth = 1;
    _Segment.selectedSegmentIndex=self.index;
    
    [_Segment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
}

-(void)createScrollView{
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    _scrollView.frame = CGRectMake(0, 60, Screen_Width, Screen_Height-KNavigationBarHeight-60);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = false;
    _scrollView.scrollsToTop=NO;
    //方向锁
    _scrollView.directionalLockEnabled = YES;
    //为scrollview设置大小  需要计算调整
    _scrollView.contentSize = CGSizeMake(Screen_Width * 2, Screen_Height - KNavigationBarHeight-60);
    
    if (self.index==1) {
        _personalCertificateSummaryVC = [[DDPersonalCertificateSummaryVC alloc]init];
        //企业id传过去
        _personalCertificateSummaryVC.enterpriseId = _enterpriseId;
        
        _personalCertificateSummaryVC.view.frame = CGRectMake(self.index * Screen_Width, 0, Screen_Width, CGRectGetHeight(_scrollView.frame));
        _personalCertificateSummaryVC.mainViewContoller = self;
        [_scrollView addSubview:_personalCertificateSummaryVC.view];
        [_scrollView setContentOffset:CGPointMake(self.index*Screen_Width, 0) animated:YES];
    }
}

-(void)setUpDefaultViewControll{
    _enterpriseCertificateSummaryVC = [[DDEnterpriseCertificateSummaryVC alloc]init];
    //企业id传过去
    _enterpriseCertificateSummaryVC.enterpriseId = _enterpriseId;
    _enterpriseCertificateSummaryVC.view.frame = CGRectMake(0, 0, Screen_Width, CGRectGetHeight(_scrollView.frame));
    _enterpriseCertificateSummaryVC.mainViewContoller = self;
    [_scrollView addSubview:_enterpriseCertificateSummaryVC.view];
}

-(void)segmentSelect:(UISegmentedControl*)seg{
    _selectIndex = seg.selectedSegmentIndex;
    if (_selectIndex == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
       if([_isOpen integerValue] != 0){
            self.navigationItem.rightBarButtonItem = [DDUtils rightbuttonItemWithTitle:@"考试培训" titleColor:KColorFindingPeopleBlue target:self action:@selector(rightButtonClick)];
        }
    }
    if (_selectIndex==1 && _personalCertificateSummaryVC==nil) {
        _personalCertificateSummaryVC = [[DDPersonalCertificateSummaryVC alloc]init];
        //企业id传过去
        _personalCertificateSummaryVC.enterpriseId = _enterpriseId;
        _personalCertificateSummaryVC.view.frame = CGRectMake(_selectIndex * Screen_Width, 0, Screen_Width, CGRectGetHeight(_scrollView.frame));
        _personalCertificateSummaryVC.mainViewContoller = self;
        [_scrollView addSubview:_personalCertificateSummaryVC.view];
    }
    
    [_scrollView setContentOffset:CGPointMake(_selectIndex*Screen_Width, 0) animated:YES];
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger ratio = round(offSetX / Screen_Width);
    _Segment.selectedSegmentIndex = ratio;
    
    if (ratio==1 && _personalCertificateSummaryVC==nil) {
        _personalCertificateSummaryVC = [[DDPersonalCertificateSummaryVC alloc]init];
        //企业id传过去
        _personalCertificateSummaryVC.enterpriseId = _enterpriseId;
        _personalCertificateSummaryVC.view.frame = CGRectMake(ratio * Screen_Width, 0, Screen_Width, CGRectGetHeight(_scrollView.frame));
        _personalCertificateSummaryVC.mainViewContoller = self;

        [_scrollView addSubview:_personalCertificateSummaryVC.view];
    }
    
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
