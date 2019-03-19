//
//  DDGlobalListVC.m
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDGlobalListVC.h"
#import "DDCompanyListVC.h"//公司列表页面
#import "DDPeopleListVC.h"//人员列表页面
#import "DDProjectListVC.h"//项目列表页面
#import "DDNavigationUtil.h"
@interface DDGlobalListVC ()<UITextFieldDelegate,UIScrollViewDelegate>

{
    UIView *_topBgView;
    UITextField *_textField;
    
    //NSString *_localSearchText;
}
@property(nonatomic,strong)UISegmentedControl *Segment;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)DDCompanyListVC *companyListVC;//公司列表页面
@property(nonatomic,strong)DDPeopleListVC *peopleListVC;//人员列表页面
@property(nonatomic,strong)DDProjectListVC *projectListVC;//项目列表页面


@end

@implementation DDGlobalListVC

-(void)viewWillDisappear:(BOOL)animated{
    [_topBgView removeFromSuperview];
    //还原导航底部线条颜色
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [DDNavigationUtil setNavigationBottomLineNomalColor:self.navigationController];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:_topBgView];
    //导航底部线条设为透明
    [DDNavigationUtil setNavigationBottomLineClearColor:self.navigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
   
    if (_globalListType == DDGlobalListTypeHistory) {
        [_textField resignFirstResponder];
    }else{
        [_textField becomeFirstResponder];
    }
    [self createSegmnet];
    [self createScrollView];
    //[self setUpDefaultViewControll];
    
#pragma mark - 禁止左滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];

    
}

//定制导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorWhite;
    self.navigationItem.leftBarButtonItem=[DDUtils leftButtonItemWithImage:@"Nav_back_blue" highlightedImage:@"Nav_back_blue" target:self action:@selector(leftBackClick)];
    
    _topBgView=[[UIView alloc]initWithFrame:CGRectMake(60, 4.5, Screen_Width-80, 35)];
    _topBgView.backgroundColor=KColorSearchTextFieldGrey;
    _topBgView.layer.cornerRadius=3;
    _topBgView.clipsToBounds=YES;
    [self.navigationController.navigationBar addSubview:_topBgView];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"cm_Search_icon"];
    [_topBgView addSubview:imageView];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, Screen_Width-80-10-20-10, 35)];
    _textField.delegate=self;
    _textField.text=self.searchText;
    [_textField setValue:KColorGreyLight forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:kFontSize30 forKeyPath:@"_placeholderLabel.font"];
    _textField.clearButtonMode=UITextFieldViewModeAlways;
    [_topBgView addSubview:_textField];
    _textField.returnKeyType = UIReturnKeySearch;
    //添加观察文本框的改变
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)leftBackClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//返回上一页
-(void)popBackClick{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //先发通知收弹出视图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenActionView" object:nil];
    self.indexBlock(_index);
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.navigationController==NULL) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenActionView" object:nil];
        self.indexBlock(_index);
    }
}

//创建segment
-(void)createSegmnet{
    UIView *segmentView= [[UIView alloc]init];
    segmentView.backgroundColor = kColorWhite;
    [self.view addSubview:segmentView];
    //segmentView本身
    segmentView.frame=CGRectMake(0, 0, Screen_Width, 60);

    //segmentView下面的线
    UIView *lineView= [[UIView alloc]init];
    lineView.frame=CGRectMake(0, 59.5, Screen_Width, 0.5);
    lineView.backgroundColor = kColorNavBottomLineGray;
    [self.view addSubview:lineView];
    

    //segment本身
    NSArray * segmentArray = @[@"企业",@"人员",@"中标"];
    _Segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
    [segmentView addSubview:_Segment];
    _Segment.frame=CGRectMake(25, 12.5, Screen_Width-50, 35);


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
    _scrollView.backgroundColor=[UIColor clearColor];
    //_scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = false;
    _scrollView.scrollsToTop=NO;
    //方向锁
    //_scrollView.directionalLockEnabled = YES;
    _scrollView.scrollEnabled=NO;
    //为scrollview设置大小  需要计算调整
    _scrollView.contentSize = CGSizeMake(Screen_Width * 3, Screen_Height - KNavigationBarHeight-60);
    
    if (_companyListVC==nil) {
        _companyListVC = [[DDCompanyListVC alloc]init];
        _companyListVC.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-60);
        _companyListVC.mainViewContoller = self;
        _companyListVC.searchText=@"";
        //[_companyListVC requestData];
        [_scrollView addSubview:_companyListVC.view];
    }
    
    if (_peopleListVC==nil) {
        _peopleListVC = [[DDPeopleListVC alloc]init];
        _peopleListVC.view.frame = CGRectMake(Screen_Width, 0,Screen_Width, Screen_Height-KNavigationBarHeight-60);
        _peopleListVC.mainViewContoller = self;
        _peopleListVC.searchText=@"";
        //[_peopleListVC requestData];
        [_scrollView addSubview:_peopleListVC.view];
    }
    
    if (_projectListVC==nil) {
        _projectListVC = [[DDProjectListVC alloc]init];
        _projectListVC.view.frame = CGRectMake(Screen_Width*2, 0, Screen_Width, Screen_Height-KNavigationBarHeight-60);
        _projectListVC.mainViewContoller = self;
        _projectListVC.searchText=@"";
        //[_projectListVC requestData];
        [_scrollView addSubview:_projectListVC.view];
    }
    
    if (_index==0) {
        _companyListVC.searchText=self.searchText;
        [_companyListVC requestData];
    }
    else if(_index==1){
        _peopleListVC.searchText=self.searchText;
        [_peopleListVC requestData];
    }
    else if(_index==2){
        _projectListVC.searchText=self.searchText;
        [_projectListVC requestData];
    }
    
    [_scrollView setContentOffset:CGPointMake(_index*Screen_Width, 0) animated:NO];
}

#pragma mark - segment选择点击事件
-(void)segmentSelect:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
    _index=index;
    [_scrollView setContentOffset:CGPointMake(index*Screen_Width, 0) animated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenActionView" object:nil];
    
    if (_index==0) {
        if (![_companyListVC.searchText isEqualToString:_textField.text]) {
            _companyListVC.searchText=_textField.text;
            [_companyListVC requestData];
        }

    }
    else if(_index==1){
        if (![_peopleListVC.searchText isEqualToString:_textField.text]) {
            _peopleListVC.searchText=_textField.text;
            [_peopleListVC requestData];
        }

    }
    else if(_index==2){
        if (![_projectListVC.searchText isEqualToString:_textField.text]) {
            _projectListVC.searchText=_textField.text;
            [_projectListVC requestData];
        }

    }
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

#pragma mark 监听文本框文字的改变,此时要关联三个子页面的刷新
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *rang = textField.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
        if ([textField.text isEqual:@""]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            self.indexBlock(_index);
            [self popBackClick];
        }
        else{
            if (textField.text.length<2) {
                self.searchStringBlock(textField.text);
                [self.navigationController popViewControllerAnimated:NO];
            }
            else{
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                [self performSelector:@selector(sendNotice:) withObject:textField.text afterDelay:0.5];
                //_localSearchText=textField.text;
                //[[NSNotificationCenter defaultCenter]postNotificationName:@"globalSearchNotice" object:nil userInfo:@{@"searchText":textField.text}];
            }
        }
    }
}

-(void)sendNotice:(NSString *)text{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"globalSearchNotice" object:nil userInfo:@{@"searchText":text}];

    
    if (_index==0) {
        _companyListVC.searchText=_textField.text;
        [_companyListVC requestData];
        
    }
    else if(_index==1){
        _peopleListVC.searchText=_textField.text;
        [_peopleListVC requestData];
        
    }
    else if(_index==2){
        _projectListVC.searchText=_textField.text;
        [_projectListVC requestData];
        
    }
    
    
//    if (_index==0) {
//        [_companyListVC requestData];
//    }
//    else if(_index==1){
//        [_peopleListVC requestData];
//    }
//    else if(_index==2){
//        [_projectListVC requestData];
//    }
}


@end
