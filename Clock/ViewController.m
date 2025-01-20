//
//  ViewController.m
//  Clock
//
//  Created by Evan Matthew on 19/1/2568 BE.
//

#import "ViewController.h"
#import "TimerViewController.h"
#import "AlarmViewController.h"
#import "StopwatchViewController.h"
#import "WorldClockViewController.h"


@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // Do any additional setup after loading the view.
    // Create and set up the Tab Bar Controller
      UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.tintColor = [UIColor systemOrangeColor];
      // Create view controllers for each tab
      TimerViewController *timerVC = [[TimerViewController alloc] init];
      timerVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Time" image:[UIImage systemImageNamed:@"timer"] tag:0];
      
      AlarmViewController *alarmVC = [[AlarmViewController alloc] init];
      alarmVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Alarm" image:[UIImage systemImageNamed:@"alarm"] tag:1];
      
      StopwatchViewController *stopwatchVC = [[StopwatchViewController alloc] init];
      stopwatchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Timer" image:[UIImage systemImageNamed:@"stopwatch"] tag:2];
      
      WorldClockViewController *worldClockVC = [[WorldClockViewController alloc] init];
      worldClockVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"World Clock" image:[UIImage systemImageNamed:@"globe"] tag:3];
      
      // Add the view controllers to the Tab Bar Controller
      tabBarController.viewControllers = @[timerVC, alarmVC, stopwatchVC, worldClockVC];
      
      // Add the Tab Bar Controller's view to the current view
    [self addChildViewController:tabBarController];
       [self.view addSubview:tabBarController.view];
       [tabBarController didMoveToParentViewController:self];
}


@end
