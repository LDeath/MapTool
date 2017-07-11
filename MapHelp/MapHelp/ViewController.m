//
//  ViewController.m
//  MapHelp
//
//  Created by 高赛 on 2017/7/7.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "ViewController.h"
#import "MAFMapTool.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface ViewController ()

@property (nonatomic, strong) MAFMapTool *mapTool;

@end

@implementation ViewController

- (MAFMapTool *)mapTool {
    if (_mapTool == nil) {
        _mapTool = [[MAFMapTool alloc] init];
    }
    return _mapTool;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mapTool needShowAnnotationWithIsNeedSearch:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIView *mapView = [self.mapTool getMAMapViewWithFrame:self.view.bounds];
    ///把地图添加至view
    [self.view addSubview:mapView];
    
//    [self.mapTool setOfflineMap];
    [self.mapTool checkOfflineMap];
    [self.mapTool downloadNationWideOfflineMap];
    [self.mapTool downloadCityOfflineMapWithCityCode:@"023"];
    [self.mapTool initLocationMap];
//    [self.mapTool singleLocationWithLocationBlock:^(BOOL isSuccess, NSString *latitude, NSString *longitude, BOOL isHaveInfo, NSString *address, NSString *name, NSString *cityCode, NSString *adCode) {
//        
//    }];
//    [self.mapTool startAlwaysLocationWithLocationBlock:^(BOOL isSuccess, NSString *latitude, NSString *longitude, BOOL isHaveInfo, NSString *address, NSString *name, NSString *cityCode, NSString *adCode) {
//        
//    }];
    
//    [self.mapTool searchKeyWord:@"舜泰广场" andPage:1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
