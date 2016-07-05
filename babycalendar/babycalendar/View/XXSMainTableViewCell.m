//
//  XXSMainTableViewCell.m
//  babycalendar
//
//  Created by 君の神様 on 16/5/8.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSMainTableViewCell.h"
#import "XXSActivityData.h"

@interface XXSMainTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *babyBehavior;
@property (weak, nonatomic) IBOutlet UIImageView *babyImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameAndCreatedTime;

@end

@implementation XXSMainTableViewCell

- (void)setData:(XXSActivityData *)data {
    [self.babyImage setImage:[UIImage imageWithData:data.photo]];
    self.babyBehavior.text = data.behavior;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *str = [NSString stringWithFormat:@"%ld",data.createdTime];
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *date = [formatter stringFromDate:detailDate];
    self.userNameAndCreatedTime.text = [NSString stringWithFormat:@"admin，%@",date];
    self.timeMonthLabel.text = [NSString stringWithFormat:@"%@月",[date substringToIndex:2]];
    self.timeDayLabel.text = [date substringWithRange:NSMakeRange(3, 2)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
