//
//  StopwatchViewController.m
//  Clock
//
//  Created by Evan Matthew on 19/1/2568 BE.
//
#import <AudioToolbox/AudioToolbox.h> //for system wide audio and native audio...
#import <AVFoundation/AVFoundation.h>
#import "StopwatchViewController.h"

@interface StopwatchViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *timeData;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer; //msuic or sound
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
    // Create floating timer view
    UIView *floatingTimer = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 300, 250)];
    floatingTimer.backgroundColor = [UIColor systemOrangeColor];
    floatingTimer.layer.cornerRadius = 10;
    floatingTimer.layer.shadowColor = [UIColor blackColor].CGColor;
    floatingTimer.layer.shadowOpacity = 0.5;
    floatingTimer.layer.shadowOffset = CGSizeMake(0, 4);
    floatingTimer.layer.shadowRadius = 4;
    [self.view addSubview:floatingTimer];
    
    // Add pan gesture to make the floating timer draggable
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [floatingTimer addGestureRecognizer:panGesture];
    
    // Add close button to the floating timer
    UIButton *closeTimer = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 40, 40)];
    [closeTimer setTitle:@"✕" forState:UIControlStateNormal];
    [closeTimer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeTimer.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [closeTimer addTarget:self action:@selector(closeFloatingTimer:) forControlEvents:UIControlEventTouchUpInside];
    [floatingTimer addSubview:closeTimer];
    
    // Add a label to display the countdown
    UILabel *countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    countdownLabel.textAlignment = NSTextAlignmentCenter;
    countdownLabel.font = [UIFont boldSystemFontOfSize:30];
    countdownLabel.textColor = [UIColor blackColor];
    [floatingTimer addSubview:countdownLabel];
    
    // Calculate the total time in seconds
    NSInteger hours = [self.timePicker selectedRowInComponent:0];
    NSInteger minutes = [self.timePicker selectedRowInComponent:1];
    NSInteger seconds = [self.timePicker selectedRowInComponent:2];
    __block NSInteger totalTime = (hours * 3600) + (minutes * 60) + seconds;
    NSLog(@"Timer started: %02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds);
    
    // Update the countdown label
    countdownLabel.text = [self timeStringFromSeconds:totalTime];
    
    // Start a timer to count down
    __weak typeof(self) weakSelf = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (totalTime > 0) {
            totalTime--;
            countdownLabel.text = [weakSelf timeStringFromSeconds:totalTime];
        } else {
            [timer invalidate];
            countdownLabel.text = @"Time's up!";
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // Simple vibration sound
                    
                    // Play custom sound (e.g., a beep sound)
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"7120-download-iphone-6-original-ringtone-42676" ofType:@"mp3"];
                    NSURL *url = [NSURL fileURLWithPath:path];
                    weakSelf.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                    [weakSelf.audioPlayer play];
                    
                    [timer invalidate];
        }
    }];
}

#pragma mark - Helper Methods

- (NSString *)timeStringFromSeconds:(NSInteger)seconds {
    NSInteger hours = seconds / 3600;
    NSInteger minutes = (seconds % 3600) / 60;
    NSInteger remainingSeconds = seconds % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)remainingSeconds];
}



- (void)handleDrag:(UIPanGestureRecognizer *)gesture {
    UIView *menu = gesture.view;
    CGPoint translation = [gesture translationInView:self.view];
    menu.center = CGPointMake(menu.center.x + translation.x, menu.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
}

//all of those are old methods
- (void)stopTimer {
   NSLog(@"Timer stopped.");
}

//- (void)closeFloatingTimer:(UIButton *)sender {
    // Remove the floating timer from its superview
   // [sender.superview removeFromSuperview];
//}

- (void)closeFloatingTimer:(UIButton *)sender {
    // The sender (UIButton) is part of the floating menu, so we can get its superview
    UIView *floatingTimer = sender.superview;
    
    // Remove the floating menu from its superview
    [floatingTimer removeFromSuperview];
    
    // Stop the audio player if it's playing
    [self.audioPlayer stop];
    self.audioPlayer = nil; // Clean up the audio player
    
    // Invalidate the timer if it's running
   
}



@end

