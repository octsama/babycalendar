//
//  XXSMainViewController.m
//  babycalendar
//
//  Created by 君の神様 on 16/2/24.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSMainViewController.h"
#import "CLWeeklyCalendarView.h"
#import "XXSAddViewController.h"
#import "XXSMainTableViewCell.h"
#import "XXSActivityData.h"
#import "XXSDBManager.h"
#import "XXSDetailViewController.h"

static NSString *BabyCellIdentifier = @"XXSBabyCell";
static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@interface XXSMainViewController ()<CLWeeklyCalendarViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)CLWeeklyCalendarView *calendarView;
@property (nonatomic, strong)NSMutableArray *dataArray;
//@property (nonatomic, strong)UITableView *tableView;
@end


@implementation XXSMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"mainIcon"] selectedImage:[UIImage imageNamed:@"mainIcon"]];
    }
    return self;
}

//- (NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.calendarView];
    [_tableView registerNib:[UINib nibWithNibName:@"XXSMainTableViewCell" bundle:nil] forCellReuseIdentifier:BabyCellIdentifier];
    self.title = @"主页";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBabyActivity)];
//    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = 320;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.top.equalTo(self.calendarView.mas_bottom);
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self requestBabyData];
    
}

- (void)requestBabyDataByCreatedTime:(NSString *)timeStr {
    NSMutableArray *alldata = [[XXSDBManager dbManager] queryData];
    NSMutableArray *tempData = [NSMutableArray array];
    if (alldata) {
        for (XXSActivityData *data in alldata) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
            [formatter setDateFormat:@"MM-dd"];
            NSString *str = [NSString stringWithFormat:@"%ld",data.createdTime];
            NSTimeInterval time = [str doubleValue];
            NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *date = [formatter stringFromDate:detailDate];
            if ([date isEqualToString:timeStr]) {
                [tempData addObject:data];
            }
        }
        self.dataArray = tempData;
    }
}

- (void)addBabyActivity {
    XXSAddViewController *addViewController = [[XXSAddViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

//初始化
- (CLWeeklyCalendarView *)calendarView {
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

#pragma mark - UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXSMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BabyCellIdentifier];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XXSActivityData *data = self.dataArray[indexPath.row];
    XXSDetailViewController *detailController = [[XXSDetailViewController alloc] initWithData:data];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - CLWeeklyCalendarViewDelegate

-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @1,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}

-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *timeStr = [formatter stringFromDate:date];
    [self requestBabyDataByCreatedTime:timeStr];
    NSLog(@"%@",timeStr);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
