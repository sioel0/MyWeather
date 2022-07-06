//
//  CityList.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import "CityList.h"

@interface CityList()

@property (strong, nonatomic) NSMutableArray *list;

@end

@implementation CityList

// add new city only if it is not already in the list
-(void)addCity:(City *)city {
    for(City* c in self.list) {
        if([c.name isEqual:city.name])
            return;
    }
    [self.list addObject:city];
}

-(void)removeCity:(City *)city {
    [self.list removeObject:city];
}

-(NSArray *)getAll {
    return self.list;
}

@end
