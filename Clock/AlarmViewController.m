//
//  AlarmViewController.m
//  Clock
//
//  Created by Evan Matthew on 19/1/2568 BE.
//

#import "AlarmViewController.h"

@interface AlarmViewController ()
@property (nonatomic, strong) UILabel *headerLabel;
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 50)];
    self.headerLabel.text = @"SOON!";
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.textColor = [UIColor orangeColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:self.headerLabel];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
