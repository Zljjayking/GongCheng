//
//  DDPersonCertificateCell.h
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPersonCertificateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIView *line;

- (void)loadWithTltle:(NSString*)title myRow:(NSInteger)myRow  pointRow:(NSInteger)pointRow;

+(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
