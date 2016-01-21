//
//  ViewController.m
//  BobBudowniczy
//
//  Created by Mateusz Rokosz-Sliwa on 08.01.2016.
//  Copyright © 2016 Mateusz Rokosz-Sliwa. All rights reserved.
//

#import "ViewController.h"

@interface BBViewController ()

@property (nonatomic, strong) NSMutableArray* Building; //budynek
@property (nonatomic, assign) int FloorsToBeBuilt;
@property (nonatomic, assign) int FloorsToBeDemolished;
@property (nonatomic, assign) int SpaceOnTheFloorMin;
@property (nonatomic, assign) int SpaceOnTheFloorMax;
@property (nonatomic, assign) int SpaceInTheRoom;
- (void)Build;
- (void)Demolition;
- (NSMutableArray *)InitBuilding:(int)capacity;
- (NSMutableArray *)FillFloors:(int)capacity :(int)Floor;
- (NSMutableArray *)FillRooms:(int)capacity :(int)Floor  :(int)Room;
- (NSMutableArray *)GenerateUniqueRandomNumbers :(int)amount :(int)maximum;

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.FloorsToBeBuilt = 7;
    self.FloorsToBeDemolished = 2;
    self.SpaceOnTheFloorMax = 5;
    self.SpaceOnTheFloorMin = 2;
    self.SpaceInTheRoom = 8;
    
    [self Build];
    
    [NSThread sleepForTimeInterval:2.0f];
    
    [self Demolition];
    
}

- (NSMutableArray *)FillRooms:(int)capacity :(int)Floor :(int)Room {
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:capacity];
    
    NSArray *FurnitureTypes = @[@"sofa", @"chair", @"table",
                                @"desk", @"chaise_longue"];
    
    for (int i = 1; i <= capacity; i++) {
        
        int r = arc4random_uniform((int)[FurnitureTypes count]) + 1;
        r--;
        
        [returnArray addObject:FurnitureTypes[r]];
        
        NSLog(@"Furniture placed: %@",FurnitureTypes[r]);
    }
    return returnArray;
}

- (NSMutableArray *)FillFloors:(int)capacity :(int)Floor {
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:capacity];
    if (Floor != 3 && Floor != 4) {
        for (int i = 1; i <= capacity; i++) {
            NSLog(@"Room number %d on floor %d created", i, Floor);
            
            int r = arc4random_uniform(self.SpaceInTheRoom) + 1;
            
            [returnArray addObject:[self FillRooms:r :Floor :i]];
        }
    }
    else {
        NSLog(@"Floor number %d is empty", Floor);
    }
    return returnArray;
}

- (NSMutableArray *)InitBuilding:(int)capacity {
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (int i = 1; i <= capacity; i++) {
        NSLog(@"Floor number %d built", i);
        
        int r = arc4random_uniform(self.SpaceOnTheFloorMax) + self.SpaceOnTheFloorMin;
        
        [returnArray addObject:[self FillFloors:r :i]];
        
        NSLog(@"Floor number %d finished", i);
    }
    return returnArray;
}

- (NSMutableArray *)GenerateUniqueRandomNumbers :(int)amount :(int)maximum {
    
    NSMutableArray *returnArray=[[NSMutableArray alloc] init];
    int randNum = arc4random_uniform(maximum) + 1;
    int counter=0;
    while (counter<amount) {
        if (![returnArray containsObject:[NSNumber numberWithInt:randNum]]) {
            [returnArray addObject:[NSNumber numberWithInt:randNum]];
            counter++;
        }else{
            randNum = arc4random_uniform(maximum) + 1;
        }
    }
    
    return returnArray;
}

- (void)Build {
    
    self.Building = [self InitBuilding:self.FloorsToBeBuilt];
    
    NSLog(@"Building finished!");
    
    NSLog(@"%@",self.Building);
    
    
}

- (void)Demolition {
    
    int FloorsCount = (int)[self.Building count];
    
    NSMutableArray *toBeDemolished = [[NSMutableArray alloc] init];
    
    toBeDemolished = [self GenerateUniqueRandomNumbers:self.FloorsToBeDemolished :FloorsCount];
    
    NSLog(@"%@",toBeDemolished);
    
    NSMutableArray *DemolishedFloors = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[toBeDemolished count]; i++) {
        
        int rowName = [toBeDemolished[i] intValue];
        int rowID = rowName -1;
        
        NSString *rowTitle = [NSString stringWithFormat:@"Floor %d",rowName];
        
        NSMutableArray *Row = [[NSMutableArray alloc] init];
        
        [Row addObject:rowTitle];
        
        [Row addObject:self.Building[i]];
        
        [DemolishedFloors addObject:Row];
        
        NSLog(@"%@",Row);
        
        [self.Building replaceObjectAtIndex:rowID withObject:[NSNull null]];
        
    }
    
    NSLog(@"%@",self.Building);
    
    NSLog(@"Demolition completed!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
