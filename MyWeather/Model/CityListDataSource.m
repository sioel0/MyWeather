//
//  CityListDataSource.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import "CityListDataSource.h"
#import "CityList.h"

@interface CityListDataSource()

@property (strong, nonatomic) CityList *list;

-(void) addSampleCities;

@end

@implementation CityListDataSource

-(NSArray *)getCities {
    return [self.list getAll];
}

-(void) addSampleCities {
    [self.list addCity:[[City alloc] initWithName:@"Londra"]];
    [self.list addCity:[[City alloc] initWithName:@"Dublino"]];
    [self.list addCity:[[City alloc] initWithName:@"Parigi"]];
    [self.list addCity:[[City alloc] initWithName:@"Berlino"]];
    [self.list addCity:[[City alloc] initWithName:@"Roma"]];
    [self.list addCity:[[City alloc] initWithName:@"Amsterdam"]];
    [self.list addCity:[[City alloc] initWithName:@"Praga"]];
}

@end
