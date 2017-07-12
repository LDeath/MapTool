//
//  MAFMapTool.m
//  MapHelp
//
//  Created by 高赛 on 2017/7/7.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "MAFMapTool.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MAFMapTool()<AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate>

/**
 地图视图
 */
@property (nonatomic, strong) MAMapView *mapView;
/**
 地图视图的大小
 */
@property ( nonatomic, assign) CGRect frame;
/**
 地图中心标注
 */
@property (nonatomic, strong) MAPointAnnotation *annotation;
/**
 检索api
 */
@property (nonatomic, strong) AMapSearchAPI *search;
/**
 定位api
 */
@property (nonatomic, strong) AMapLocationManager *locationManager;
/**
 是否开启了持续定位 (yes开启 no关闭 )
 */
@property (nonatomic, assign) BOOL isStratAlwaysLocation;
/**
 是否开启周边搜索
 */
@property (nonatomic, assign) BOOL isNeedSearch;

@end

@implementation MAFMapTool

- (MAMapView *)mapView {
    if (_mapView == nil) {
        ///初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:self.frame];
        _mapView.delegate = self;
        _mapView.zoomLevel = 17; //设置缩放级别,必须要在设置中心圆点之前设置
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.rotateEnabled= NO;    //NO表示禁用旋转手势，YES表示开启
        _mapView.rotateCameraEnabled= NO;    //NO表示禁用倾斜手势，YES表示开启
        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
        
        r.lineWidth = 0;///精度圈 边线宽度，默认0
        r.enablePulseAnnimation = YES;///内部蓝色圆点是否使用律动效果, 默认YES
        [_mapView updateUserLocationRepresentation:r];
    }
    return _mapView;
}
- (AMapSearchAPI *)search {
    if (_search == nil) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
#pragma mark 初始化
/**
 初始化地图sdk
 */
- (void)initMapWithKey:(NSString *)key {
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = key;
}
#pragma mark 获取地图
/**
 根据frame获取地图视图
 */
- (UIView *)getMAMapViewWithFrame:(CGRect )frame {
    
    self.frame = frame;

    return self.mapView;
}
#pragma mark 大头针
/**
 需要显示大头针
 */
- (void)needShowAnnotationWithIsNeedSearch:(BOOL)isNeedSearch {
    self.isNeedSearch = isNeedSearch;
    self.annotation = [[MAPointAnnotation alloc] init];
    self.annotation.lockedToScreen = YES;
    self.annotation.lockedScreenPoint = CGPointMake(self.mapView.frame.size.width / 2, self.mapView.frame.size.height / 2);
    [self.mapView addAnnotation:self.annotation];
}
#pragma mark MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    [mapView deselectAnnotation:self.annotation animated:NO];
}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (self.isNeedSearch) {
        [self searchPOIWithPage:1];
    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
#pragma mark 检索
/**
 关键字检索
 */
- (void)searchKeyWord:(NSString *)keyWord andPage:(NSInteger )page {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = keyWord;
    request.requireExtension    = YES;
    request.offset = 20;
    request.page = page;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    NSString *locationCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationCity"];
    if (locationCity != nil && ![locationCity isEqualToString:@""]) {
        request.city = locationCity;
    }
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}
/**
 根据大头针的位置检索
 */
- (void)searchPOIWithPage:(NSInteger )page {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.mapView.region.center.latitude longitude:self.mapView.region.center.longitude];
    request.keywords            = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    request.radius = 500;
    request.page = page;
    request.offset = 21;
    [self.search AMapPOIAroundSearch:request];
}
#pragma mark AMapSearchDelegate检索代理
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (request.offset == 20) {// 关键字检索
        if (self.keyWordSearchBlock == NULL || self.keyWordSearchBlock == nil) {
            return;
        }
        self.keyWordSearchBlock(response.pois, request.page);
    } else {// 位置检索
        if (request.page == 1) {
            AMapPOI *poiModel = response.pois.firstObject;
            self.annotation.title = poiModel.name;
            self.annotation.subtitle = poiModel.address;
        }
        if (self.poiSearchBlock == NULL || self.poiSearchBlock == nil) {
            return;
        }
        self.poiSearchBlock(response.pois, request.page);
    }
}
#pragma mark 离线地图
/**
 初始化离线地图plist数据
 */
- (void)setOfflineMap {
    NSArray *cityArr = [MAOfflineMap sharedOfflineMap].cities;
    if (cityArr == nil || cityArr.count == 0) {
        [[MAOfflineMap sharedOfflineMap] setupWithCompletionBlock:^(BOOL setupSuccess) {
            NSLog(@"%d",setupSuccess);
        }];
    }
}
/**
 监测新版本。注意：如果有新版本，会重建所有的数据，包括provinces、municipalities、nationWide、cities，
 */
- (void)checkOfflineMap {
    [[MAOfflineMap sharedOfflineMap] checkNewestVersion:^(BOOL hasNewestVersion) {
        if (!hasNewestVersion) {// 不需要更新
            return;
        }
        if (self.offlineUpdateBlock == NULL || self.offlineUpdateBlock == nil) {
            return;
        }
        self.offlineUpdateBlock(YES);
    }];
}
/**
 下载全国概要离线地图
 */
- (void)downloadNationWideOfflineMap {
    [self downloadOfflineMapWithItem:[MAOfflineMap sharedOfflineMap].nationWide];
}
/**
 根据城市id下载对应城市离线地图
 */
- (void)downloadCityOfflineMapWithCityCode:(NSString *)cityCode {
    NSArray *arr = [MAOfflineMap sharedOfflineMap].cities;
    for (MAOfflineItemMunicipality *cityModel in arr) {
        if ([cityCode isEqualToString:cityModel.cityCode]) {
            [self downloadOfflineMapWithItem:cityModel];
        }
    }
}
/**
 暂停全国概要图下载
 */
- (void)pauseWithNationWide {
    [[MAOfflineMap sharedOfflineMap] pauseItem:[MAOfflineMap sharedOfflineMap].nationWide];
}
/**
 根据城市编号暂停下载
 */
- (void)pauseWithCityCode:(NSString *)cityCode {
    NSArray *arr = [MAOfflineMap sharedOfflineMap].cities;
    for (MAOfflineItemMunicipality *cityModel in arr) {
        if ([cityCode isEqualToString:cityModel.cityCode]) {
            [[MAOfflineMap sharedOfflineMap] pauseItem:cityModel];
        }
    }
}
/**
 删除全国概要图离线地图数据
 */
- (void)deleteNationWide {
    [[MAOfflineMap sharedOfflineMap] deleteItem:[MAOfflineMap sharedOfflineMap].nationWide];
}
/**
 根据城市id删除对应城市离线地图数据
 */
- (void)deleteWithCityCode:(NSString *)cityCode {
    NSArray *arr = [MAOfflineMap sharedOfflineMap].cities;
    for (MAOfflineItemMunicipality *cityModel in arr) {
        if ([cityCode isEqualToString:cityModel.cityCode]) {
            [[MAOfflineMap sharedOfflineMap] deleteItem:cityModel];
        }
    }
}
/**
 取消全部下载
 */
- (void)cancleAllDownload {
    [[MAOfflineMap sharedOfflineMap] cancelAll];
}
- (void)downloadOfflineMapWithItem:(MAOfflineItem *)item {
    [[MAOfflineMap sharedOfflineMap] downloadItem:item shouldContinueWhenAppEntersBackground:YES downloadBlock:^(MAOfflineItem *downloadItem, MAOfflineMapDownloadStatus downloadStatus, id info) {
        
        if (self.offlineDownloadBlock == NULL || self.offlineDownloadBlock == nil) {
            return;
        }
        if (downloadStatus == MAOfflineMapDownloadStatusCompleted) {// 下载成功
            self.offlineDownloadBlock(0);
        } else if (downloadStatus == MAOfflineMapDownloadStatusCancelled) {// 取消
            self.offlineDownloadBlock(1);
        } else if (downloadStatus == MAOfflineMapDownloadStatusError) {// 发生错误
            self.offlineDownloadBlock(2);
        } else if (downloadStatus == MAOfflineMapDownloadStatusProgress) {// 下载过程中
            self.offlineDownloadBlock(3);
        } else if (downloadStatus == MAOfflineMapDownloadStatusFinished) {// 全部下载完成
            self.offlineDownloadBlock(4);
        }
    }];
}
#pragma mark 定位
/**
 初始化定位
 */
- (void)initLocationMap {
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置定位最小更新距离方法如下，单位米。当两次定位距离满足设置的最小更新距离时，SDK会返回符合要求的定位结果
    self.locationManager.distanceFilter = 5;
    //持续定位是否返回逆地理信息，默认NO
    self.locationManager.locatingWithReGeocode = YES;
    //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }else {
        //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    }
}
/**
 发起单次定位
 */
- (void)singleLocationWithLocationBlock:(MapLocationBlock )locationBlock {
    self.signleLocationBlock = locationBlock;
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =5;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 5;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            self.signleLocationBlock(NO, @"", @"", NO, @"", @"", @"", @"", location, regeocode);
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
            return;
        }
        NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        if (regeocode) {
            self.signleLocationBlock(YES, latitude, longitude, YES, regeocode.formattedAddress, regeocode.POIName, regeocode.citycode, regeocode.adcode, location, regeocode);
        } else {
            self.signleLocationBlock(YES, latitude, longitude, NO, @"", @"", @"", @"", location, regeocode);
        }
    }];
}
/**
 开启持续定位
 */
- (void)startAlwaysLocationWithLocationBlock:(MapLocationBlock )locationBlock {
    if (!self.isStratAlwaysLocation) {
        self.alwaysLocationBlock = locationBlock;
        [self.locationManager setLocatingWithReGeocode:YES];
        [self.locationManager startUpdatingLocation];
        self.isStratAlwaysLocation = YES;
    }
}
/**
 停止持续定位
 */
- (void)stopAlwaysLocation {
    [self.locationManager stopUpdatingLocation];
}
#pragma mark AMapLocationManagerDelegate定位代理
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    if (reGeocode)
    {
        self.alwaysLocationBlock(YES, latitude, longitude, YES, reGeocode.formattedAddress, reGeocode.POIName, reGeocode.citycode, reGeocode.adcode, location, reGeocode);
    } else {
        self.alwaysLocationBlock(YES, latitude, longitude, NO, @"", @"", @"", @"", location, reGeocode);
    }
}


@end
