//
//  DDBidMoneyCell.h
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBidMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *greaterThanLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UITextField *maxMoneyTextFileld;
@property (weak, nonatomic) IBOutlet UITextField *minMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *unit2Lab;

- (void)loadWithMinMoney:(NSString*)minMoney maxMoney:(NSString*)maxMoney;

+(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
