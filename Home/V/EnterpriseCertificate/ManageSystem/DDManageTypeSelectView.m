//
//  DDManageTypeSelectView.m
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDManageTypeSelectView.h"

@interface DDManageTypeSelectView()
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation DDManageTypeSelectView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, -Screen_Height,Screen_Width,(Screen_Height-44-KNavigationBarHeight));
        self.backgroundColor = [UIColor clearColor];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
//        [self addGestureRecognizer:tap];
        
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI{
//    //tableView上部
//    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, (44+KNavigationBarHeight))];
//    topView.backgroundColor = [UIColor clearColor];
//    [self addSubview:topView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, Screen_Width, (44*5)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = KColorTableSeparator;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,KTableViewFooterViewHeight)];
    [self addSubview:_tableView];
    
    //tableView下部
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,BOTTOM(_tableView), Screen_Width, (Screen_Height- BOTTOM(_tableView)))];
    bottomView.backgroundColor = KColor70AlphaBlack;
    [self addSubview:bottomView];
    
}
- (void)showInView:(UIView*)view{
    [view addSubview:self];
    self.frame = CGRectMake(0,44, Screen_Width,(Screen_Height-44-KNavigationBarHeight));
}

- (void)hide{
    if ([_delegate respondsToSelector:@selector(manageTypeSelectViewWillDisappear:)]) {
        [_delegate manageTypeSelectViewWillDisappear:self];
    }
    self.frame = CGRectMake(0, -Screen_Height,Screen_Width, (Screen_Height-44-KNavigationBarHeight));
}
- (void)hiddenSelf{
    [self hide];
}
#pragma mark set方法
- (void)setPointRow:(NSUInteger)pointRow{
    _pointRow = pointRow;
    [_tableView reloadData];
}
#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * systemCellID = @"DDEmailInvoiceDetailVC";
    UITableViewCell * systemCell = [tableView dequeueReusableCellWithIdentifier:systemCellID];
    if (systemCell == nil) {
        systemCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:systemCellID];
    }
    systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    systemCell.accessoryType = UITableViewCellAccessoryNone;
    
    NSArray * titles = [[NSArray alloc] initWithObjects:@"全部",@"建筑施工行业质量管理体系认证(GB/T50430)",@"质量管理体系认证(ISO90001)",@"环境管理体系认证(ISO14001)",@"职业健康安全管理体系认证(OHSAS18001)", nil];
    systemCell.textLabel.text = titles[indexPath.row];
    systemCell.textLabel.font = kFontSize28;
    
    //选中的是蓝色
    if (_pointRow == indexPath.row) {
        systemCell.textLabel.textColor = kColorBlue;
    }else{
        systemCell.textLabel.textColor = KColorBlackTitle;
    }
    
    return systemCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hide];
    
    if ([_delegate respondsToSelector:@selector(manageTypeSelectViewSelected:pointRow:)]) {
        [_delegate manageTypeSelectViewSelected:self pointRow:indexPath.row];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
