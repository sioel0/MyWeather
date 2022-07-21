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

@end

@implementation CityListDataSource

-(CityList *)getCities {
    return self.list;
}

-(instancetype)init {
    if(self = [super init]) {
        _list = [[CityList alloc] init];
    }
    return self;
}

@end
