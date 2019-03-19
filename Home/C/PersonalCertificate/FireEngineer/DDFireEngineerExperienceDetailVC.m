//
//  DDFireEngineerExperienceDetailVC.m
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDFireEngineerExperienceDetailVC.h"
#import "DataLoadingView.h"
#import "DDNoResult2View.h"//无数据视图
#import "MJRefresh.h"
#import "DDFireEngineerExperienceCell.h"//cell
#import "DDFireEngineerExperienceModel.h"//model

@interface DDFireEngineerExperienceDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger currentPage;
    NSInteger pageCount;
    
    NSMutableDictionary *_dict;
    
    
    UILabel *_numLabel;
    UILabel *_rightLab;
    BOOL isLastData;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) DataLoadingView *loadingView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong)UILabel *leftLab;

@end

@implementation DDFireEngineerExperienceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"执业经历";
    self.navigationItem.leftBarButtonItem = [DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    [self createSummaryLab];
    [self.view addSubview:self.tableView];
    
    [self setupDataLoadingView];
    [self requestData:YES];
}

#pragma mark 返回上一页
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createSummaryLab{
    //搜索结果统计
    UIView *summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
    [self.view addSubview:summaryView];
    
    _leftLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 60, 15)];
    _leftLab.text=@"共承接过";
    _leftLab.textColor=KColorGreySubTitle;
    _leftLab.font=kFontSize26;
    [summaryView addSubview:_leftLab];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, 1, 15)];
    _numLabel.text=@"";
    _numLabel.textColor=KColorBlackTitle;
    _numLabel.font=kFontSize26;
    [summaryView addSubview:_numLabel];
    
    _rightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 150, 15)];
    _rightLab.text=@"个项目";
    _rightLab.textColor=KColorGreySubTitle;
    _rightLab.font=kFontSize26;
    [summaryView addSubview:_rightLab];
}

- (void)setupDataLoadingView{
    __weak __typeof(self) weakSelf=self;
    _loadingView = [[DataLoadingView alloc] initWithController:self];
    _loadingView.loadingTitle = KLoading;
    _loadingView.failureTitle = KLoadingFailure;
    _loadingView.reloadHandle = ^(void){
        [weakSelf requestData:YES];
    };
    [_loadingView showLoadingView];
}

- (void)requestData:(BOOL)isRefresh{
    if (isRefresh) {
        currentPage = 1;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.staffId forKey:@"id"];
    [params setValue:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"current"];
    [params setValue:@"10" forKey:@"size"];
    
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_fireEngineerExperienceDetail params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            currentPage += 1;
            if (isRefresh) {
                [self.dataSourceArr removeAllObjects];
                if (self.tableView.mj_footer) {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
            [_loadingView hiddenLoadingView];
            _dict = responseObject[KData];
            pageCount = [_dict[@"totalCount"] integerValue];
          
            _leftLab.text=[NSString stringWithFormat:@"共承接过%ld个项目",(long)pageCount];
            NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:_leftLab.text];
            [attStr addAttribute:NSForegroundColorAttributeName value:KColorBlackSubTitle range:NSMakeRange(4, _leftLab.text.length-7)];
            _leftLab.attributedText = attStr;
            
            
            NSArray *orderArr = [[NSArray alloc]init];
            NSArray *listArr=_dict[@"list"];
            orderArr = [DDFireEngineerExperienceModel mj_objectArrayWithKeyValuesArray:listArr];
            [_dataSourceArr addObjectsFromArray:orderArr];
            if (_dataSourceArr.count<pageCount) {
                isLastData = NO;
            }else{
                isLastData = YES;
            }
            [self.tableView reloadData];
            [self endRefrshing:YES];
        }else{
            [self endRefrshing:NO];
            [_loadingView failureLoadingView];
        }
            
            //给数量label赋值
//            NSString *totlaNum=[NSString stringWithFormat:@"%@",_dict[@"totalCount"]];
//            _numLabel.text=totlaNum;
//            CGRect numberFrame = [totlaNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSize30} context:nil];
//            _numLabel.frame=CGRectMake(CGRectGetMaxX(_leftLab.frame)+2, 15, numberFrame.size.width, 15);
//            _rightLab.frame=CGRectMake(CGRectGetMaxX(_numLabel.frame)+2, 15, 150, 15);
            
            
//            if (listArr.count!=0) {
//                [_noResultView hide];
//
//                for (NSDictionary *dic in listArr) {
//                    DDFireEngineerExperienceModel *model = [[DDFireEngineerExperienceModel alloc]initWithDictionary:dic error:nil];
//                    [_dataSourceArr addObject:model];
//                }
//
//                if (listArr.count<pageCount) {
//                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                        [weakSelf addData];
//                    }];
//                }else{
//                    [_tableView.mj_footer removeFromSuperview];
//                }
//            }
//            else{
//                [_noResultView showWithTitle:@"暂无相关消防工程师执业经历的信息" subTitle:@"去其他地方看看~" image:@"noResult_person"];
//            }
//
//        }
//        else{
//
//            [_loadingView failureLoadingView];
//        }
//
//        [self.tableView.mj_header endRefreshing];
//        [_tableView reloadData];
//        if (_dataSourceArr.count>0) {
//            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        }
    }  failure:^(NSURLSessionDataTask *operation, id responseObject)  {
        [self endRefrshing:NO];
        [DDUtils showToastWithMessage:kRequestFailed];
        [_loadingView failureLoadingView];
    }];
}

-(void)endRefrshing:(BOOL)requestSucceed
{
    if (_tableView) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header  endRefreshing];
        }
        if (requestSucceed) {
            if (isLastData==NO && !self.tableView.mj_footer) {
                //如果不是最后一条数据 设置footer
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self requestData:NO];
                }];
            }
            else if (isLastData == YES && !self.tableView.mj_footer)
            {
                return;
            }
            else if(isLastData == YES && self.tableView.mj_footer)
            {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                if (_tableView.mj_footer.isRefreshing) {
                    [_tableView.mj_footer endRefreshing];
                }
            }
        }
        else
        {
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
        }
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataSourceArr.count == 0) {
        return 1;
    }
    return _dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSourceArr.count==0) {
        static  NSString *reuseId = @"UITableViewCell";
        UITableViewCell  *noDataCell =[tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!noDataCell) {
            noDataCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            noDataCell.selectionStyle=UITableViewCellSelectionStyleNone;
            DDNoResult2View *noResultView=[[DDNoResult2View alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frameWidth, self.tableView.frameHeight)];
            [noResultView showWithTitle:@"没有相关内容~" subTitle:nil image:@"noResult_content"];
            [noDataCell.contentView addSubview:noResultView];
            
        }
        return noDataCell;
    }
    DDFireEngineerExperienceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDFireEngineerExperienceCell" forIndexPath:indexPath];
    DDFireEngineerExperienceModel *model=_dataSourceArr[indexPath.section];
    [cell loadDataWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSourceArr.count == 0) {
        return self.tableView.frameHeight;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_dataSourceArr.count > 0) {
        if (section == 0) {
            return WidthByiPhone6(45);
        }
    }
    return WidthByiPhone6(15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_dataSourceArr.count > 0) {
        if (section == 0) {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(45))];
            [headView addSubview:self.leftLab];
            [self.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headView).offset(WidthByiPhone6(12));
                make.centerY.equalTo(headView);
            }];
            return headView;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma mark -- lazyload
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight-KHomeIndicatorHeight) tstyle:UITableViewStyleGrouped tdelegate:self tdatasource:self backgroundColor:kColorBackGroundColor sepratorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.rowHeight=UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight=100;
        [_tableView registerNib:[UINib nibWithNibName:@"DDFireEngineerExperienceCell" bundle:nil] forCellReuseIdentifier:@"DDFireEngineerExperienceCell"];
        
        kWeakSelf
        _tableView.mj_header=[MJRefreshStateHeader  headerWithRefreshingBlock:^{
            [weakSelf requestData:YES];
        }];
    }
    return _tableView;
}
-(UILabel *)leftLab{
    if(!_leftLab){
        _leftLab = [UILabel labelWithFont:kFontSize26 textColor:KColorGreySubTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _leftLab;
}
-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
@end
