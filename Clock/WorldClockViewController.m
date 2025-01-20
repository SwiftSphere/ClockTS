#import "WorldClockViewController.h"
#import "AppDelegate.h"
@interface WorldClockViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *Button;
@property (nonatomic, strong) UIPickerView *timeZonePicker;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *startMenu;
@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) NSMutableArray *floatingMenus;
@end

@implementation WorldClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.floatingMenus = [NSMutableArray array]; // Initialize the array
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add the "New" button to the view
    self.Button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.Button setTitle:@"New" forState:UIControlStateNormal];
    [self.Button addTarget:self action:@selector(newButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.Button.translatesAutoresizingMaskIntoConstraints = NO;
    self.Button.tintColor = [UIColor systemOrangeColor];
    [self.view addSubview:self.Button];

    // Position the button at the top-right corner
    [NSLayoutConstraint activateConstraints:@[
        [self.Button.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.Button.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10]
    ]];
    
    self.hideButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.hideButton setTitle:@"Hide" forState:UIControlStateNormal];
    [self.hideButton addTarget:self action:@selector(hideButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.hideButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.hideButton.tintColor = [UIColor systemBlueColor];
    [self.view addSubview:self.hideButton];

    // Position the `hideButton` at the top-left corner
    [NSLayoutConstraint activateConstraints:@[
        [self.hideButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.hideButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10]
    ]];

    
    


    // List of cities to show in the picker
    self.cities = @[
        @"Moscow", @"Berlin", @"New York", @"Tokyo", @"London",
        @"Sydney", @"Paris", @"Beijing", @"Los Angeles", @"São Paulo", @"Dubai", @"Cairo", @"Cape Town", @"Seoul", @"Mumbai"
    ];
    
    // Set up the picker view for selecting a city
    self.timeZonePicker = [[UIPickerView alloc] init];
    self.timeZonePicker.delegate = self;
    self.timeZonePicker.dataSource = self;
    self.timeZonePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.timeZonePicker];
    self.timeZonePicker.hidden = !self.timeZonePicker.hidden;
    [NSLayoutConstraint activateConstraints:@[
        [self.timeZonePicker.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.timeZonePicker.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:50], // Move it down by 50 points
        [self.timeZonePicker.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.timeZonePicker.heightAnchor constraintEqualToConstant:200],
    ]];

   
    CGFloat centerX = self.view.frame.size.width / 2.0;
    CGFloat centerY = self.view.frame.size.height / 2.0 - 50; // Slightly above center

    // Adjusted width and height for longer text
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - 150, centerY - 20, 300, 60)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:24];
    self.timeLabel.numberOfLines = 0; // Allow multiple lines if needed
    self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping; 
    self.timeLabel.textColor = [UIColor systemOrangeColor];   // Prevent truncation

    // Add the label to the view
    [self.view addSubview:self.timeLabel];

    //[NSLayoutConstraint activateConstraints:@[
    //    [self.timeLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50],
     //   [self.timeLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    //]];

    self.selectedCity = self.cities[0]; // Default selection
    [self updateCityTime]; // Initial time update
    // Create the button
    self.startMenu = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.startMenu setTitle:@"Add as a stick" forState:UIControlStateNormal];
    [self.startMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // Text color
    self.startMenu.titleLabel.font = [UIFont boldSystemFontOfSize:20]; // Bold and larger font
    self.startMenu.backgroundColor = [UIColor systemOrangeColor]; // Button background color
    self.startMenu.layer.cornerRadius = 10; // Rounded corners
    self.startMenu.layer.shadowColor = [UIColor blackColor].CGColor; // Add shadow
    self.startMenu.layer.shadowOpacity = 0.5;
    self.startMenu.layer.shadowOffset = CGSizeMake(0, 4);
    self.startMenu.layer.shadowRadius = 4;
    self.startMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self.startMenu addTarget:self action:@selector(startMenuTapped) forControlEvents:UIControlEventTouchUpInside]; // Add action
    [self.view addSubview:self.startMenu];

    // Position it below the picker
    [NSLayoutConstraint activateConstraints:@[
        [self.startMenu.topAnchor constraintEqualToAnchor:self.timeZonePicker.bottomAnchor constant:20], // Below the picker
        [self.startMenu.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor], // Center horizontally
        [self.startMenu.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.6], // 60% of screen width
        [self.startMenu.heightAnchor constraintEqualToConstant:50] // Fixed height
    ]];

}


// MARK: - Button Action

- (void)newButtonTapped {
    // Display the picker when the "New" button is tapped
   // self.timeZonePicker.hidden = !self.timeZonePicker.hidden;
    self.timeZonePicker.hidden = NO;
}

// MARK: - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.cities.count;
}

// MARK: - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.cities[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // Update the selected city when the user picks one
    self.selectedCity = self.cities[row];
    // Update the displayed time for the selected city
    [self updateCityTime];
}

// MARK: - Helper Method to Update Time

- (void)updateCityTime {
    // You can extend this to handle different time zones for each city.
    // For simplicity, this example assumes the current local time.
    
    // Time zone mapping for cities (for demonstration purposes)
    NSDictionary *cityTimeZones = @{
     //   @"Moscow": @"Europe/Moscow",
     //   @"Berlin": @"Europe/Berlin",
     //   @"New York": @"America/New_York",
     //   @"Tokyo": @"Asia/Tokyo",
     //   @"London": @"Europe/London",
     //   @"Sydney": @"Australia/Sydney",
     //   @"Paris": @"Europe/Paris",
     //   @"Beijing": @"Asia/Shanghai",
     //   @"Los Angeles": @"America/Los_Angeles",
     //   @"São Paulo": @"America/Sao_Paulo"
        @"Moscow" :@"Europe/Moscow",
        @"Berlin" :@"Europe/Berlin",
        @"New York" : @"America/New_York",
         @"Tokyo" :@"Asia/Tokyo",
        @"London" :@"Europe/London",
        @"Sydney": @"Australia/Sydney",
        @"Paris" :@"Europe/Paris",
        @"Beijing": @"Asia/Shanghai",
        @"Los Angeles" : @"America/Los_Angeles",
        @"São Paulo" : @"America/Sao_Paulo",
        @"Cape Town" : @"Africa/Johannesburg",
         @"Dubai":@"Asia/Dubai",
        @"Seoul" : @"Asia/Seoul",
        @"Mumbai" : @"Asia/Kolkata",
          @"Cairo" :@"Africa/Cairo"
    };
    
    NSString *timeZoneName = cityTimeZones[self.selectedCity];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    
    // Get current time in the selected city's time zone
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    [formatter setTimeZone:timeZone];
    
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    // Update the label with the selected city's time
    self.timeLabel.text = [NSString stringWithFormat:@"%@ Time: %@", self.selectedCity, currentTime];
}

- (void)startMenuTapped {
    // Create the floating menu
    UIView *floatingMenu = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 250, 200)];
    floatingMenu.backgroundColor = [UIColor systemOrangeColor];
    floatingMenu.layer.cornerRadius = 10;
    floatingMenu.layer.shadowColor = [UIColor blackColor].CGColor;
    floatingMenu.layer.shadowOpacity = 0.5;
    floatingMenu.layer.shadowOffset = CGSizeMake(0, 4);
    floatingMenu.layer.shadowRadius = 4;
    
    
    
    // Add a gesture recognizer for dragging
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [floatingMenu addGestureRecognizer:panGesture];
    [self.floatingMenus addObject:floatingMenu];
    // Add a label to the menu
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 230, 40)];
    menuLabel.text = self.timeLabel.text;
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.textColor = [UIColor whiteColor];
    menuLabel.font = [UIFont boldSystemFontOfSize:16];
    [floatingMenu addSubview:menuLabel];

    // Add a close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitle:@"undo" forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(10, 150, 230, 40);
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeFloatingMenu:) forControlEvents:UIControlEventTouchUpInside];
    [floatingMenu addSubview:closeButton];
    
    // Add a TextView for the user to input multi-line text
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, 230, 80)];
    textView.text = @"Editable multi-line text here...";
    textView.font = [UIFont systemFontOfSize:16];
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor lightGrayColor];
    textView.layer.cornerRadius = 8;
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 1.0;
    textView.editable = YES;
    textView.scrollEnabled = YES;
    [floatingMenu addSubview:textView];

    // Add the floating menu to the view
    [self.view addSubview:floatingMenu];
}



// Handle dragging of the floating menu
- (void)handleDrag:(UIPanGestureRecognizer *)gesture {
    UIView *menu = gesture.view;
    CGPoint translation = [gesture translationInView:self.view];
    menu.center = CGPointMake(menu.center.x + translation.x, menu.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
}

// Close the floating menu
//- (void)closeFloatingMenu {
    //[self.floatingMenus addObject:floatingMenu];
   // UIView *floatingMenu = [self.view viewWithTag:101];
  //  [floatingMenu removeFromSuperview];
//i need to understand which view gonna be closed
    
//}

- (void)closeFloatingMenu:(UIButton *)sender {
    // The sender (UIButton) is part of the floating menu, so we can get its superview
    UIView *floatingMenu = sender.superview;
    
    // Remove the floating menu from its superview
    [floatingMenu removeFromSuperview];
}


- (void)hideButtonTapped {
    // Toggle visibility of the picker or other UI elements
    self.timeZonePicker.hidden = YES;
}



@end

