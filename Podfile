platform :ios,'8.0'

target 'sndonongshang' do
pod 'YTKNetwork'
pod 'MJRefresh'
pod 'Masonry'
pod 'MBProgressHUD'
pod 'SDCycleScrollView'
pod 'FDFullscreenPopGesture'
pod 'YYText'
pod 'YYKeyboardManager' #监控键盘弹出隐藏
pod 'YYImage' #GIF
pod 'YYModel' #
pod 'WCDB'
pod 'DZNEmptyDataSet' #无数据页面
pod 'IQKeyboardManager' #键盘管理
pod 'SAMKeychain' #钥匙串
pod 'SVProgressHUD'
pod 'iCarousel'

# 友盟
pod 'UMCShare/UI'
pod 'UMCCommon'
pod 'UMCSecurityPlugins'
pod 'UMCAnalytics'
pod 'UMCShare/Social/WeChat'
pod 'UMCShare/Social/QQ'
pod 'UMCShare/Social/Sina'
#pod 'UMCPush'

pod 'MJExtension'
pod 'CYLTabBarController'
pod 'KMNavigationBarTransition'
# 搜索框
pod 'PYSearch'
pod 'DateTools'

# 高德地图
pod 'AMapLocation-NO-IDFA'
pod 'AMapSearch-NO-IDFA'

pod 'GTMBase64'
# 内存检测
#pod 'MLeaksFinder'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end

end
