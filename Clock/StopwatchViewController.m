//
//  StopwatchViewController.m
//  Clock
//
//  Created by Evan Matthew on 19/1/2568 BE.
//

#import "StopwatchViewController.h"

@interface StopwatchViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *timeData;
@end

@implementation StopwatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Header Label
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 50)];
    self.headerLabel.text = @"Set Timer";
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.textColor = [UIColor orangeColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:self.headerLabel];

    // Start Button
    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.startButton.frame = CGRectMake(50, self.view.frame.size.height - 150, 120, 50);
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    self.startButton.backgroundColor = [UIColor systemGreenColor];
    self.startButton.layer.cornerRadius = 25;
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];

    // Stop Button
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.stopButton.frame = CGRectMake(self.view.frame.size.width - 170, self.view.frame.size.height - 150, 120, 50);
    [self.stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    self.stopButton.backgroundColor = [UIColor systemRedColor];
    self.stopButton.layer.cornerRadius = 25;
    self.stopButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.stopButton addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stopButton];

    // Picker View for Time
    self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.timePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.timePicker];

    // Time Data (Hours, Minutes, Seconds)
    NSMutableArray *hours = [NSMutableArray array];
    NSMutableArray *minutesAndSeconds = [NSMutableArray array];
    for (int i = 0; i <= 23; i++) {
        [hours addObject:@(i)];
    }
    for (int i = 0; i <= 59; i++) {
        [minutesAndSeconds addObject:@(i)];
    }
    self.timeData = @[hours, minutesAndSeconds, minutesAndSeconds];
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3; // Hours, Minutes, Seconds
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.timeData[component].count;
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%02ld", (long)[self.timeData[component][row] integerValue]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width / 3; // Equal width for each component
}

#pragma mark - Timer Actions

- (void)startTimer {
    UIView *floatingTimer = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 300, 250)];
    floatingTimer.backgroundColor = [UIColor systemOrangeColor];
    floatingTimer.layer.cornerRadius = 10;
    floatingTimer.layer.shadowColor = [UIColor blackColor].CGColor;
    floatingTimer.layer.shadowOpacity = 0.5;
    floatingTimer.layer.shadowOffset = CGSizeMake(0, 4);
    floatingTimer.layer.shadowRadius = 4;
    [self.view addSubview:floatingTimer];
    NSInteger hours = [self.timePicker selectedRowInComponent:0];
    NSInteger minutes = [self.timePicker selectedRowInComponent:1];
    NSInteger seconds = [self.timePicker selectedRowInComponent:2];
    NSLog(@"Timer started: %02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds);
}

- (void)stopTimer {
    NSLog(@"Timer stopped.");
}

@end

