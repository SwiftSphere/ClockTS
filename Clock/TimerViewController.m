#import "TimerViewController.h"

@interface TimerViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *regularCities;
@property (nonatomic, strong) NSArray *easterEggCities;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // List of regular cities and their time zones
    self.regularCities = @[
        @{@"name": @"Moscow", @"timezone": @"Europe/Moscow"},
        @{@"name": @"Berlin", @"timezone": @"Europe/Berlin"},
        @{@"name": @"New York", @"timezone": @"America/New_York"},
        @{@"name": @"Tokyo", @"timezone": @"Asia/Tokyo"},
        @{@"name": @"London", @"timezone": @"Europe/London"},
        @{@"name": @"Sydney", @"timezone": @"Australia/Sydney"},
        @{@"name": @"Paris", @"timezone": @"Europe/Paris"},
        @{@"name": @"Beijing", @"timezone": @"Asia/Shanghai"},
        @{@"name": @"Los Angeles", @"timezone": @"America/Los_Angeles"},
        @{@"name": @"São Paulo", @"timezone": @"America/Sao_Paulo"},
        @{@"name": @"Cape Town", @"timezone": @"Africa/Johannesburg"},
        @{@"name": @"Dubai", @"timezone": @"Asia/Dubai"},
        @{@"name": @"Seoul", @"timezone": @"Asia/Seoul"},
        @{@"name": @"Mumbai", @"timezone": @"Asia/Kolkata"},
        @{@"name": @"Cairo", @"timezone": @"Africa/Cairo"}
    ];
    
    // List of Easter egg cities
    self.easterEggCities = @[
        @{@"name": @"Honolulu", @"timezone": @"Pacific/Honolulu"},
        @{@"name": @"Reykjavik", @"timezone": @"Atlantic/Reykjavik"},
        @{@"name": @"Antarctica", @"timezone": @"Antarctica/South_Pole"},
        @{@"name": @"Atlantis", @"timezone": @"Legend/Atlantis"} // Easter egg city
    ];
    
    // Set up the table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // Two sections: Regular cities and Easter egg cities
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.regularCities.count;
    } else {
        return self.easterEggCities.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CityTimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *cityInfo;
    if (indexPath.section == 0) {
        cityInfo = self.regularCities[indexPath.row];
    } else {
        cityInfo = self.easterEggCities[indexPath.row];
    }
    
    NSString *cityName = cityInfo[@"name"];
    NSString *timezone = cityInfo[@"timezone"];
    
    // Get the current time for the city's timezone
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timezone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    [formatter setTimeZone:timeZone];
    
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    // Configure the cell
    cell.textLabel.text = cityName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Time: %@", currentTime];
    
    return cell;
}

// MARK: - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Cities with Current Time";  // The heading for regular cities section
    } else {
        return @"🥶😭😭😭";  // The heading for Easter egg cities section
    }
}

@end

