//
//  DBManager.m
//  LimitFreeProject
//


#import "DBManager.h"
#import "MXNewsModel.h"

//全局变量
/*
 数据库
 1.导入 libsqlite3.dylib
 2.导入 fmdb
 3.导入头文件
 fmdb 是对底层C语言的sqlite3的封装
 
 */
@implementation DBManager
{
    //数据库对象
    FMDatabase *_database;
}
//非标准单例
+ (DBManager *)sharedManager {
    static DBManager *manager = nil;
    @synchronized(self) {//同步 执行 防止多线程操作
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        NSString *docPath=[NSHomeDirectory() stringByAppendingFormat:@"/Documents"];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"app.db"];
        //2.创建database
        _database = [[FMDatabase alloc] initWithPath:filePath];
        //3.open
        //第一次 数据库文件如果不存在那么 会创建并且打开
        //如果存在 那么直接打开
        if ([_database open]) {
          //  NSLog(@"%@",filePath);
            //创建表 不存在 则创建
            [self creatTable];
        }else {
            NSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
}
#pragma mark - 创建表
- (void)creatTable {
    //字段: 应用名 应用id 当前价格 最后价格 icon地址 记录类型 价格类型
    NSString *sql = @"create table if not exists appInfo(serial integer Primary Key Autoincrement,title Varchar(1024),uid Varchar(1024))";
    //创建表 如果不存在则创建新的表
    BOOL isSuccees = [_database executeUpdate:sql];
    if (!isSuccees) {
        NSLog(@"creatTable error:%@",_database.lastErrorMessage);
    }
}


-(BOOL)isExistModelWithuid:(NSString *)uid{
 NSString *sql=@"select * from appInfo where uid = ?";
    FMResultSet *rs=[_database executeQuery:sql,uid];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }
    
}
-(void)insertModel:(MXNewsModel *)model{
    if ([self isExistModelWithuid:model.uid]) {
        return;
    }
    NSString *sql=@"insert into appInfo(title,uid) values(?,?)";
    if (![_database executeUpdate:sql,model.title,model.uid]) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelWithuid :(NSString *)uid{
    NSString *sql = @"delete from appInfo where uid = ?";
    BOOL isSuccess = [_database executeUpdate:sql,uid];
    if (!isSuccess) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}


- (NSArray *)fetchAllData{
    
    NSString *sql = @"select * from appInfo";
    FMResultSet * rs = [_database executeQuery:sql];

    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([rs next]) {
        //把查询之后结果 放在model
        MXNewsModel *appModel = [[MXNewsModel alloc] init];
        appModel.title=[rs stringForColumn:@"title"];
        appModel.uid=[rs stringForColumn:@"uid"];//放入数组
        [arr addObject:appModel];
    }
    return arr;
}


@end
