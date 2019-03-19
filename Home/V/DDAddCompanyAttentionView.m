//
//  DDAddCompanyAttentionView.m
//  GongChengDD
//
//  Created by csq on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDAddCompanyAttentionView.h"

@implementation DDAddCompanyAttentionView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = KColor70AlphaBlack;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    _titleLab.text = @"选择关注信息类别";
    _titleLab.textColor = KColorBlackTitle;
    _titleLab.font = KFontSize42;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    _subTitleLab.text = @"选择你关心的该企业信息类别，工程点点将会相应推送此类信息的动态【最新中标信息，最新信息证书变更】";
    _subTitleLab.numberOfLines = 0;
    _subTitleLab.textColor = KColorGreySubTitle;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _bottomline.backgroundColor = KColorTableSeparator;
    _bottonCenterLine.backgroundColor = KColorTableSeparator;
    
    
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:KColorChangeTelGray forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = kFontSize34;
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_sureButtton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButtton setTitleColor:kColorBlue forState:UIControlStateNormal];
    _sureButtton.titleLabel.font = kFontSize34;
    [_sureButtton addTarget:self action:@selector(sureButttonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"DDAddCompanyAttentionCell";
    DDAddCompanyAttentionCell * cell = (DDAddCompanyAttentionCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * titles = [[NSArray alloc] initWithObjects:@"中标情况",@"证书动态",@"以上全部关注", nil];
    
    return cell;
}

#pragma mark --
- (void)cancelButtonClick{
    [self hide];
}
- (void)sureButttonClick{
    
}
- (void)show{
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
