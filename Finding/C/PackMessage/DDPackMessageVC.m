//
//  DDPackMessageVC.m
//  GongChengDD
//
//  Created by csq on 2019/1/4.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDPackMessageVC.h"
#import "MJRefresh.h"
#import "DDPeopleSummaryCell.h"

@interface DDPackMessageVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataSourceArr;
    NSInteger currentPage;
    NSMutableDictionary *_dict;

}
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,strong) UILabel *topLabels;

@end

@implementation DDPackMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.enterpriseName;
    [self editNavItem];
    [self setupHeadview];
    [self createTableView];
    [self requestData];

}
- (void)setupHeadview
{
    UIView *tview = [[UIView alloc]init];
    tview.frame = CGRectMake(0, 0, Screen_Width, 45);
    
    [self.view addSubview:tview];
    //给数量label赋值
    CGRect nameFrame = [self.updateTimeString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];

    self.topLabels = [[UILabel alloc]init];
    self.topLabels.textAlignment = NSTextAlignmentLeft;
    self.topLabels.font = kFontSize28;
    self.topLabels.frame = CGRectMake(10, 0, nameFrame.size.width, tview.frame.size.height);
    self.topLabels.textColor = kColorBlack;
    self.topLabels.text = self.updateTimeString;
    
    [tview addSubview:self.topLabels];
    
    CGRect nameFrame1 = [self.daoqitixingStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize28} context:nil];

    UILabel *labelss = [[UILabel alloc]init];
    labelss.textAlignment = NSTextAlignmentLeft;
    labelss.font = kFontSize28;
    labelss.frame = CGRectMake(CGRectGetMaxX(self.topLabels.frame)+2, 0, nameFrame1.size.width, tview.frame.size.height);
    labelss.textColor = KColorGreySubTitle;
    labelss.text = self.daoqitixingStr;
    [self changeLabel:labelss withTextColor:kColorBlack];
    [tview addSubview:labelss];

    
}
- (void)changeLabel:(UILabel *)label withTextColor:(UIColor *)color {
    if (label.text.length == 0) {
        return;
    }
    NSString *labelStr = label.text; //初始化string为传入label.text的值
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];//创建一个字符串过滤参数,decimalDigitCharacterSet为过滤小数,过滤某个关键词,只需改变 decimalDigitCharacterSet类型  在将此方法增加一个 NSString参数即可
    NSInteger remainSeconde = [[labelStr stringByTrimmingCharactersInSet:nonDigits]intValue];//获取过滤出来的数值
    NSString *stringRange = [NSString stringWithFormat:@"%ld",(long)remainSeconde];//将过滤出来的Integer的值转换成String
    NSRange range = [labelStr rangeOfString:stringRange];//获取过滤出来的数值的位置
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];//创建一个带属性的string
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];//给带属性的string添加属性,attrubute:添加的属性类型（颜色\文字大小\字体等等）,value:改变成的属性参数,range:更改的位置
    label.attributedText = attrStr;//将 attstr 赋值给label带属性的文本框属性
    
    
}
//编辑导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    _dataSourceArr=[[NSMutableArray alloc]init];
    _dict=[NSMutableDictionary dictionary];
    
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建tableView
-(void)createTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollsToTop=YES;
    self.tableView.showsVerticalScrollIndicator=YES;
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView setSeparatorColor:KColorTableSeparator];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf=self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    
}
#pragma mark 请求数据
-(void)requestData{
    currentPage = 1;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"15" forKey:@"size"];
    [params setValue:_IDstr  forKey:@"id"];
    
    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_appPackMessageList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        
        if (response.isSuccess) {
            

            [_dataSourceArr removeAllObjects];

            _dict = responseObject[KData];
            NSArray *listArr=_dict[KList];
            if (listArr.count!=0) {
                _dataSourceArr = [DDPeopleSummaryModel arrayOfModelsFromDictionaries:_dict[KList] error:nil];
                if (_dataSourceArr.count< [_dict[KTotalCount] integerValue]) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf addData];
                    }];
                }else{
                    [self.tableView.mj_footer removeFromSuperview];
                }
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];

        }
        
        
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}

- (void)addData{
    currentPage++;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"15" forKey:@"size"];
    [params setValue:_IDstr  forKey:@"id"];

    [[DDHttpManager sharedInstance] sendPostRequest:KHttpRequest_appPackMessageList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        __weak __typeof(self) weakSelf = self;
        
        if (response.isSuccess) {
            
            _dict = responseObject[KData];
            
            NSArray * tempArray =  [DDPeopleSummaryModel arrayOfModelsFromDictionaries:_dict[KList] error:nil];
            [_dataSourceArr addObjectsFromArray:tempArray];

            if (_dataSourceArr.count<[_dict[KTotalCount] integerValue]) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf addData];
                }];
            }
            else{
                [self.tableView.mj_footer removeFromSuperview];
            }
        }
        else{
            [DDUtils showToastWithMessage:response.message];
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        [DDUtils showToastWithMessage:kRequestFailed];
    }];
}


#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSourceArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDPeopleSummaryModel *model=_dataSourceArr[indexPath.section];

    static NSString * cellID = @"DDPeopleSummaryCell";
    DDPeopleSummaryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.makeBtn.tag = 500+indexPath.section;
    [cell.makeBtn addTarget:self action:@selector(makeAciton:) forControlEvents:UIControlEventTouchUpInside];
    [cell loadSafeManWithModel:model indexPath:indexPath];
    return cell;
    
}
-(void)makeAciton:(UIButton *)sender{
    DDPeopleSummaryModel *model=_dataSourceArr[sender.tag-500];
    if ([model.type integerValue] == 2||[model.type integerValue] == 3) {
        [DDUtils showToastWithMessage:@"暂未开通"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     return [DDPeopleSummaryCell height];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


@end
