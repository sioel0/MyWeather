//
//  FavouritesTableViewController.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import "FavouritesTableViewController.h"
#import "CityList.h"
#import "CityListDataSource.h"
#import "MapViewController.h"

@interface FavouritesTableViewController ()

@property (strong, nonatomic) CityList *list;

@end

@implementation FavouritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Preferiti";
    self.list = [self.dataSource getCities];
    self.previous.title = @"Meteo";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list size];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    City *city = [self.list getAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *new = [self.list getAtIndex:indexPath.row];
    // update the city for weather information and go back to that view
    self.previous.city = new;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowMap"]){
        if([segue.destinationViewController isKindOfClass:[MapViewController class]]){
            MapViewController *vc = (MapViewController *)segue.destinationViewController;
            vc.currentLocation = self.previous.city;
            vc.list = self.list.getAll;
        }
    }
}


@end
