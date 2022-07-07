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

-(instancetype)init {
    if(self = [super init])
        _list = [[NSMutableArray alloc] init];
    return self;
}

// add new city only if it is not already in the list
-(void)addCity:(City *)city {
    for(City *c in self.list)
        if([c.name isEqual:city.name])
            return;
    [self.list addObject:city];
}

-(void)removeCity:(City *)city {
    [self.list removeObject:city];
}

-(NSArray *)getAll {
    return self.list;
}

-(long)size {
    return self.list.count;
}

-(City *)getAtIndex:(NSInteger)index {
    return (City *) [self.list objectAtIndex:index];
}

-(BOOL)contains:(City *)city {
    for(City *c in self.list)
        if([c.name isEqual:city.name])
            return YES;
    return NO;
}

@end
