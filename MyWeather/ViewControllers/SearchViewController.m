//
//  SearchViewController.m
//  MyWeather
//
//  Created by Simone Leoni on 21/07/22.
//

#import "SearchViewController.h"
#import "City.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *SearchResultsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong) NSArray *list;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _list = [[NSMutableArray alloc] init];
    self.SearchResultsTableView.delegate = self;
    self.SearchResultsTableView.dataSource = self;
    self.SearchBar.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    NSDictionary *cityData = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *)[cityData valueForKey:@"name"];
    cell.detailTextLabel.text = (NSString *)[cityData valueForKey:@"country"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = (NSDictionary *)[self.list objectAtIndex:indexPath.row];
    NSString *cityName = (NSString *)[data valueForKey:@"name"];
    NSNumber *lat = [data valueForKey:@"latitude"];
    NSNumber *lon = [data valueForKey:@"longitude"];
    City *new = [[City alloc] initWithName:cityName latitude:lat.doubleValue longitude:lon.doubleValue];
    self.previous.city = new;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchCity];
}

// use open-meteo api to get all the possible positions associated to the given city name
-(void) searchCity {
    NSString *searchString = self.SearchBar.text;
    NSString *escapedString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    dispatch_queue_t queue = dispatch_queue_create("search_data", NULL);
    dispatch_async(queue, ^{
        NSString *urlString = [NSString stringWithFormat: @"https://geocoding-api.open-meteo.com/v1/search?name=%@&language=it" ,escapedString];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *results = (NSDictionary *)value;
        self.list = (NSArray *)[results objectForKey:@"results"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.SearchResultsTableView reloadData];
        });
    });
}
    
@end
