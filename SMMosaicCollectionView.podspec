Pod::Spec.new do |s|
  s.name     = 'SMMosaicCollectionView'
  s.version  = '1.0.1'
  s.license  = { :type => 'MIT' }
  s.summary  = 'A lightweight hoziontal image scroller that centers on the middle cell regardless of the image\'s aspect ratio.'
  s.homepage = 'https://github.com/sammcewan/SMMosaicCollectionView'
  s.authors  = { 'Sam McEwan' => 'me@sammcewan.co.nz' }
  s.source   = { :git => 'https://github.com/sammcewan/SMMosaicCollectionView.git', :tag => 'v1.0.1' }
  s.source_files = 'Source/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.ios.frameworks = 'UIKit', 'Foundation'
end
