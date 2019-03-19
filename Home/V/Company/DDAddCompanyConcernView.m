//
//  DDAddCompanyConcernView.m
//  GongChengDD
//
//  Created by csq on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAddCompanyConcernView.h"
#import "DDAddCompanyAttentionCell.h"

@implementation DDAddCompanyConcernView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        self.backgroundColor = KColor70AlphaBlack;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
//        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setupUI{
    
    _rowArr = [[NSMutableArray alloc] initWithCapacity:3];
    

    //白色背景view
    _whiteBgView = [[UIView alloc]init];
    _whiteBgView.frame = CGRectMake(30,( (Screen_Height-365)/2), Screen_Width-60,370);
    _whiteBgView.backgroundColor = [UIColor whiteColor];
    _whiteBgView.layer.cornerRadius = 10;
    _whiteBgView.clipsToBounds = YES;
    [self addSubview:_whiteBgView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(22, 25,(WIDTH(_whiteBgView)-44), 21)];
    _titleLab.text = @"选择监控信息类别";
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font = KFontSize42;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_whiteBgView addSubview:_titleLab];
    
    NSString * subTitleString = @"选择你关心的该企业信息类别,及时获取此类信息的动态消息";
     CGFloat subTitleHeight = [DDUtils  heightForText:subTitleString withTextWidth:WIDTH(_titleLab) withFont:kFontSize26];
    _subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(22, BOTTOM(_titleLab)+18, WIDTH(_titleLab), subTitleHeight)];
    _subTitleLab.numberOfLines = 0;
    _subTitleLab.textColor = KColorGreySubTitle;
    _subTitleLab.font = kFontSize26;
    _subTitleLab.text = subTitleString;
    [_subTitleLab sizeToFit];
    [_whiteBgView addSubview:_subTitleLab];
    
    CGFloat tableViewY = (BOTTOM(_titleLab)+18+subTitleHeight+30);
    CGFloat tableViewHeight = HEIGHT(_whiteBgView)- (BOTTOM(_titleLab)+18 + subTitleHeight) - (45+30);//白色view高-tableView距上部-tableView距下部
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,tableViewY, WIDTH(_whiteBgView),tableViewHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_whiteBgView addSubview:_tableView];
    
    //底部线
    _bottomline = [[UIView alloc] initWithFrame:CGRectMake(0,(HEIGHT(_whiteBgView)-45), WIDTH(_whiteBgView), 0.5)];
    _bottomline.backgroundColor = KColorTableSeparator;
    [_whiteBgView addSubview:_bottomline];

    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0,(HEIGHT(_whiteBgView)-44),(WIDTH(_whiteBgView)/2), 45);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:KColorChangeTelGray forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = kFontSize34;
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    [_whiteBgView addSubview:_cancelButton];
    
    _sureButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButtton.frame = CGRectMake((WIDTH(_whiteBgView)/2),Y(_cancelButton),WIDTH(_cancelButton), 45);
    [_sureButtton setTitle:@"确认" forState:UIControlStateNormal];
    [_sureButtton setTitleColor:kColorBlue forState:UIControlStateNormal];
    _sureButtton.titleLabel.font = kFontSize34;
    [_sureButtton addTarget:self action:@selector(sureButttonClick) forControlEvents:UIControlEventTouchUpInside];
    _sureButtton.backgroundColor = [UIColor whiteColor];
    [_whiteBgView addSubview:_sureButtton];
    
    //中间线
    _bottonCenterLine = [[UIView alloc] initWithFrame:CGRectMake((WIDTH(_whiteBgView)/2), BOTTOM(_bottomline), 0.5, (HEIGHT(_whiteBgView)-BOTTOM(_bottomline)))];
    _bottonCenterLine.backgroundColor = KColorTableSeparator;
    [_whiteBgView addSubview:_bottonCenterLine];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDAddCompanyAttentionCell";
    DDAddCompanyAttentionCell * cell = (DDAddCompanyAttentionCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * titles = [[NSArray alloc] initWithObjects:@"中标业绩",@"企业证书",@"人员证书",@"风险信息",@"获奖荣誉",@"信用情况",@"以上全部监控", nil];
    
    //判断是否选中
    BOOL isSelected = NO;
    for (NSString * rowStr in _rowArr) {
        if ([rowStr integerValue] == indexPath.row) {
            //遍历数组,如果_rowArr包含indexPath.row,说明此row已经选中
            isSelected = YES;
            break;
        }
    }
    
    [cell loadWithTitle:titles[indexPath.row] isSelected:isSelected];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
    if (indexPath.row == 6) {
        //判断是否包含"以上全关注"
        BOOL isContent = NO;
        for (NSString * str in _rowArr) {
            if ([str integerValue] == indexPath.row) {
                //选中的数组里面有
                isContent = YES;
                break;
            }
        }
        
        if (YES == isContent) {
            //包含"以上全关注"
            [_rowArr removeAllObjects];
        }else{
            //不包含"以上全关注"
            [_rowArr removeAllObjects];
            [_rowArr addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        
    }else{
        //移除"以上全关注",
        [_rowArr removeObject:@"6"];
        
        BOOL isSelected = NO;
        NSString * rowStr = nil;
        for (NSString * str in _rowArr) {
            if ([str integerValue] == indexPath.row) {
                // 如果选中的在数组里面有 说明之前已经选中
                rowStr = str;
                isSelected = YES;
                break;
            }
        }
        
        if (isSelected == YES) {
            //之前选中的
            [_rowArr removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            //  [_rowArr removeAllObjects];
            
        }else{
            //         [_rowArr removeAllObjects];
            //之前未选中的要添加
            [_rowArr addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
    }
    
    
    [_tableView reloadData];
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
#pragma mark --
- (void)cancelButtonClick{
    //取消
    [self hide];
}
- (void)sureButttonClick{
    if (_rowArr.count == 0 ) {
        [DDUtils showToastWithMessage:@"请选择关注信息类别"];
        return;
    }
    //先隐藏本身
    [self hide];
    
//    NSString * rowString = _rowArr[0];
//    NSInteger row = [rowString integerValue];
//    //确定
//    if ([_delegate respondsToSelector:@selector(addCompanyConcernViewdidSelectRow:)]) {
//        [_delegate addCompanyConcernViewdidSelectRow:row];
//    }
    
    if ([_delegate respondsToSelector:@selector(addCompanyConcernViewdidSelectRowArray:)]) {
        [_delegate addCompanyConcernViewdidSelectRowArray:_rowArr];
    }
    
}
- (void)show{
    
    [self setupUI];
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWin = windows[0];
    UIWindow *winodw = mainWin;
    for (NSInteger  i = windows.count-1; i >= 0; i--) {
        UIWindow *win = windows[i];
        if (CGRectEqualToRect(win.bounds, mainWin.bounds) && (win.windowLevel == UIWindowLevelNormal)) {
            winodw = win;
            break;
        }
    }
    [winodw addSubview:self];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)hiddenSelf{
    [self hide];
}
@end
