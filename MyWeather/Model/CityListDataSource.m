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

-(CityList *)getCities {
    return self.list;
}

-(void)addSampleCities {
    [self.list addCity:[[City alloc] initWithName:@"Londra" latitude:51.48 longitude:-0.14]];
    [self.list addCity:[[City alloc] initWithName:@"Dublino" latitude:53.34 longitude:-6.26]];
    [self.list addCity:[[City alloc] initWithName:@"Parigi" latitude:48.85 longitude:2.32]];
    [self.list addCity:[[City alloc] initWithName:@"Berlino" latitude:52.51 longitude:13.38]];
    [self.list addCity:[[City alloc] initWithName:@"Roma" latitude:41.89 longitude:12.48]];
    [self.list addCity:[[City alloc] initWithName:@"Amsterdam" latitude:52.37 longitude:4.89]];
    [self.list addCity:[[City alloc] initWithName:@"Praga" latitude:50.08 longitude:14.42]];
}

-(instancetype)init {
    if(self = [super init]) {
        _list = [[CityList alloc] init];
        [self addSampleCities];
    }
    return self;
}

@end
